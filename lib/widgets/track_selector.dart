import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/audio_bloc.dart';
import '../bloc/audio_event.dart';
import '../bloc/audio_state.dart';
import '../models/track.dart';

class TrackSelector extends StatelessWidget {
  const TrackSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      buildWhen: (prev, curr) => prev.activeTrack.id != curr.activeTrack.id,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Track>(
              isExpanded: true,
              value: citizenDjTracks.firstWhere(
                (t) => t.id == state.activeTrack.id,
                orElse: () => citizenDjTracks.first,
              ),
              items: citizenDjTracks.map((Track track) {
                return DropdownMenuItem<Track>(
                  value: track,
                  child: Text(
                    track.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (Track? selected) {
                if (selected != null) {
                  context.read<AudioBloc>().add(SelectTrackEvent(selected));
                }
              },
            ),
          ),
        );
      },
    );
  }
}