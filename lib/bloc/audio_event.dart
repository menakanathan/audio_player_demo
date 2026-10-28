import 'package:audioplayers/audioplayers.dart';
import '../models/track.dart';

abstract class AudioEvent {
  const AudioEvent();
}

class SelectTrackEvent extends AudioEvent {
  final Track track;
  const SelectTrackEvent(this.track);
}

class PlayAudioEvent extends AudioEvent {
  const PlayAudioEvent();
}

class PauseAudioEvent extends AudioEvent {
  const PauseAudioEvent();
}

class StopAudioEvent extends AudioEvent {
  const StopAudioEvent();
}

class SeekAudioEvent extends AudioEvent {
  final Duration position;
  const SeekAudioEvent(this.position);
}

class RefreshPlaybackEvent extends AudioEvent {
  const RefreshPlaybackEvent();
}

class SyncAudioEngineEvent extends AudioEvent {
  final Duration position;
  final Duration duration;
  final PlayerState playerState;

  const SyncAudioEngineEvent({
    required this.position,
    required this.duration,
    required this.playerState,
  });
}