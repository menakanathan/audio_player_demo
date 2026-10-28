import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/audio_bloc.dart';
import '../bloc/audio_event.dart';
import '../bloc/audio_state.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      buildWhen: (prev, curr) => prev.position != curr.position || prev.duration != curr.duration,
      builder: (context, state) {
        final double posSec = state.position.inSeconds.toDouble();
        final double totalSec = state.duration.inSeconds.toDouble();
        final double maxRange = totalSec > 0 ? totalSec : 1.0;
        final double safeSliderVal = posSec.clamp(0.0, maxRange);

        return Column(
          children: [
            Slider(
              value: safeSliderVal,
              min: 0.0,
              max: maxRange,
              activeColor: const Color(0xFF007A78),
              inactiveColor: Colors.grey.shade200,
              onChanged: (val) {
                context.read<AudioBloc>().add(SeekAudioEvent(Duration(seconds: val.toInt())));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatTime(state.position), style: const TextStyle(color: Colors.black54)),
                  Text(_formatTime(state.duration), style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}