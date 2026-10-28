import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/audio_bloc.dart';
import 'bloc/audio_event.dart';
import 'bloc/audio_state.dart';
import 'widgets/controls_row.dart';
import 'widgets/progress_bar.dart';
import 'widgets/track_selector.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with WidgetsBindingObserver {
  late final AudioBloc _audioBloc;
  bool _enableBackgroundPlayback = false;

  @override
  void initState() {
    super.initState();
    _audioBloc = AudioBloc();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (!_enableBackgroundPlayback) {
      if (state != AppLifecycleState.resumed) {
        _audioBloc.add(const PauseAudioEvent());
      }
    } else {
      if (state == AppLifecycleState.resumed) {
        _audioBloc.add(const RefreshPlaybackEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _audioBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Citizen DJ Audio Archive'),
          backgroundColor: const Color(0xFF007A78),
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Switch(
                value: _enableBackgroundPlayback,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF2E8B57),
                inactiveThumbColor: Colors.white70,
                inactiveTrackColor: Colors.black26,
                onChanged: (val) {
                  setState(() {
                    _enableBackgroundPlayback = val;
                  });
                },
              ),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TrackSelector(),
                const SizedBox(height: 36),
                BlocBuilder<AudioBloc, AudioState>(
                  buildWhen: (prev, curr) =>
                      prev.activeTrack.id != curr.activeTrack.id,
                  builder: (context, state) {
                    return Column(
                      children: [
                        Text(
                          state.activeTrack.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.activeTrack.artist,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 36),
                const ProgressBar(),
                const SizedBox(height: 28),
                const ControlsRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}