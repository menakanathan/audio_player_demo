import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';

import '../bloc/audio_bloc.dart';
import '../bloc/audio_event.dart';
import '../bloc/audio_state.dart';

class ControlsRow extends StatelessWidget {
  const ControlsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      buildWhen: (prev, curr) => prev.playerState != curr.playerState,
      builder: (context, state) {
        final isPlaying = state.isPlaying;
        final isPaused = state.playerState == PlayerState.paused;
        final isStopped = state.playerState == PlayerState.stopped;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- 1. STOP BUTTON ---
            // Resets hardware buffer and snaps slider to 00:00
            IconButton(
              iconSize: 42,
              tooltip: 'Stop',
              icon: const Icon(Icons.stop_rounded),
              color: isStopped ? Colors.grey.shade400 : Colors.redAccent.shade700,
              onPressed: isStopped
                  ? null
                  : () => context.read<AudioBloc>().add(const StopAudioEvent()),
            ),
            const SizedBox(width: 20),

            // --- 2. PAUSE BUTTON ---
            // Freezes stream at current timestamp; retains seek position
            IconButton(
              iconSize: 44,
              tooltip: 'Pause',
              icon: const Icon(Icons.pause_circle_outline_rounded),
              color: isPlaying ? const Color(0xFF007A78) : Colors.grey.shade400,
              onPressed: isPlaying
                  ? () => context.read<AudioBloc>().add(const PauseAudioEvent())
                  : null,
            ),
            const SizedBox(width: 20),

            // --- 3. PLAY / RESUME BUTTON ---
            // Resumes from paused point or starts fresh from 00:00 (or seeked point)
            IconButton(
              iconSize: 56,
              tooltip: isPaused ? 'Resume' : 'Play',
              icon: Icon(
                isPaused
                    ? Icons.play_circle_outline_rounded
                    : Icons.play_circle_fill_rounded,
              ),
              color: isPlaying ? Colors.grey.shade400 : const Color(0xFF007A78),
              onPressed: isPlaying
                  ? null
                  : () => context.read<AudioBloc>().add(const PlayAudioEvent()),
            ),
          ],
        );
      },
    );
  }
}