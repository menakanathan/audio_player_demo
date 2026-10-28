import 'package:audioplayers/audioplayers.dart';
import '../models/track.dart';

class AudioState {
  final Track activeTrack;
  final Duration position;
  final Duration duration;
  final PlayerState playerState;

  bool get isPlaying => playerState == PlayerState.playing;

  const AudioState({
    required this.activeTrack,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.playerState = PlayerState.stopped,
  });

  AudioState copyWith({
    Track? activeTrack,
    Duration? position,
    Duration? duration,
    PlayerState? playerState,
  }) {
    return AudioState(
      activeTrack: activeTrack ?? this.activeTrack,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      playerState: playerState ?? this.playerState,
    );
  }
}