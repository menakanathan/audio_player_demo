import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

//audioplayers exports an internal platform class named AudioEvent, which collides with our custom AudioEvent class.
//Add hide AudioEvent to the audioplayers import on line 3 of lib/bloc/audio_bloc.dart:
import 'package:audioplayers/audioplayers.dart' hide AudioEvent;

import '../models/track.dart';
import 'audio_event.dart';
import 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription? _posSub;
  StreamSubscription? _durSub;
  StreamSubscription? _stateSub;

  AudioBloc() : super(AudioState(activeTrack: citizenDjTracks.first)) {
    // 1. Configure audio context for background playback
    // Background Enabled for audio playback
    
    _player.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gain,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: const {}, // for standard playback .. AVAudioSessionOptions.defaultToSpeaker},
      ),
    ));
    
    // Option to disable background playback if needed
    /*
    _player.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        stayAwake: false, // Releases native CPU wake-lock
        audioFocus: AndroidAudioFocus.none,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.ambient, // Stops immediately on home/lock screen
      ),
    ));
    // End of option to disable background playback if needed
    */

    // 2. Register event handlers
    on<SelectTrackEvent>(_onSelectTrack);
    on<PlayAudioEvent>(_onPlay);
    on<PauseAudioEvent>(_onPause);
    on<StopAudioEvent>(_onStop);
    on<SeekAudioEvent>(_onSeek);
    on<SyncAudioEngineEvent>(_onSyncEngine);
    on<RefreshPlaybackEvent>(_onRefreshPlayback);

    // 3. Bind engine streams to BLoC events
    _posSub = _player.onPositionChanged.listen((pos) {
      add(SyncAudioEngineEvent(
        position: pos,
        duration: state.duration,
        playerState: state.playerState,
      ));
    });

    _durSub = _player.onDurationChanged.listen((dur) {
      add(SyncAudioEngineEvent(
        position: state.position,
        duration: dur,
        playerState: state.playerState,
      ));
    });

    _stateSub = _player.onPlayerStateChanged.listen((pState) {
      add(SyncAudioEngineEvent(
        position: state.position,
        duration: state.duration,
        playerState: pState,
      ));
    });

    // 4. Set initial source
    _player.setSource(UrlSource(citizenDjTracks.first.audioUrl));
  }

  Future<void> _onSelectTrack(SelectTrackEvent event, Emitter<AudioState> emit) async {
      emit(state.copyWith(
        activeTrack: event.track,
        position: Duration.zero,
        duration: Duration.zero,
        playerState: PlayerState.stopped,
      ));
      await _player.stop();
      await _player.setSource(UrlSource(event.track.audioUrl));
    }

  // 1. STOP: Flushes pipeline, rewinds position to zero, re-arms URL source
  Future<void> _onStop(StopAudioEvent event, Emitter<AudioState> emit) async {
    await _player.stop();
    await _player.setSource(UrlSource(state.activeTrack.audioUrl));
    emit(state.copyWith(
      position: Duration.zero,
      playerState: PlayerState.stopped,
    ));
  }

  // 2. PAUSE: Halts audio output, preserves current timestamp in hardware & state
  Future<void> _onPause(PauseAudioEvent event, Emitter<AudioState> emit) async {
    await _player.pause();
    emit(state.copyWith(playerState: PlayerState.paused));
  }

  // 3. PLAY: If resumed from pause, continues; if coming from stop, loads and starts
  Future<void> _onPlay(PlayAudioEvent event, Emitter<AudioState> emit) async {
    if (state.playerState == PlayerState.paused) {
      await _player.resume();
    } else {
      await _player.play(
        UrlSource(state.activeTrack.audioUrl),
        position: state.position,
      );
    }
  }

  Future<void> _onSeek(SeekAudioEvent event, Emitter<AudioState> emit) async {
    // Optimistically update the state so the slider updates immediately
    emit(state.copyWith(position: event.position));

    if (state.playerState == PlayerState.stopped) {
      // Re-arm the source and set position if stopped
      await _player.setSource(UrlSource(state.activeTrack.audioUrl));
      await _player.seek(event.position);
    } else {
      await _player.seek(event.position);
    }
  }

/*
Flutter UI/Streams went to sleep: While the app was minimized (AppLifecycleState.paused), 
the Flutter engine paused its rendering pipeline and throttled background stream dispatches 
to save battery. The onPositionChanged stream stopped firing into the BLoC.

The BLoC state is stale: When the app is reopened,
AudioBloc still held the last position emitted right 
before the app was minimized, making the slider and timestamp appear frozen at the minimize point.

_player.getCurrentPosition() queries the native Android MediaPlayer directly 
for its hardware clock, instantly bypassing any stale Flutter streams.
*/
  Future<void> _onRefreshPlayback(
    RefreshPlaybackEvent event,
    Emitter<AudioState> emit,
  ) async {
    final currentPos = await _player.getCurrentPosition() ?? state.position;
    final currentDur = await _player.getDuration() ?? state.duration;

    emit(state.copyWith(
      position: currentPos,
      duration: currentDur,
      playerState: _player.state,
    ));
  }

  void _onSyncEngine(SyncAudioEngineEvent event, Emitter<AudioState> emit) {
    emit(state.copyWith(
      position: event.position,
      duration: event.duration,
      playerState: event.playerState,
    ));
  }

  @override
  Future<void> close() {
    _posSub?.cancel();
    _durSub?.cancel();
    _stateSub?.cancel();
    _player.dispose();
    return super.close();
  }
}