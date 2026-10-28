class Track {
  final String id;
  final String title;
  final String artist;
  final String audioUrl;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioUrl,
  });
}

const List<Track> citizenDjTracks = [
  Track(
    id: '1',
    title: 'Christmas Adventure Part 2',
    artist: 'Citizen DJ - Library of Congress',
    audioUrl: 'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/samplepacks/loc-fma/A-Christmas-adventure-Part-2_fma-184032_001_00-00-08.wav',
  ),
  Track(
    id: '2',
    title: 'Medusa',
    artist: 'Citizen DJ - Library of Congress',
    audioUrl: 'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/samplepacks/loc-fma/Medusa_fma-161439_001_00-00-45.wav',
  ),
  Track(
    id: '3',
    title: 'On the road looking at your feet',
    artist: 'Citizen DJ - Library of Congress',
    audioUrl: 'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/samplepacks/loc-fma/On-the-road-looking-at-your-feet_fma-152300_001_00-00-45.wav',
  ),
  Track(
    id: '4',
    title: 'I need a hero - figure main character theme',
    artist: 'Citizen DJ - Library of Congress',
    audioUrl: 'https://s3.amazonaws.com/citizen-dj-assets.labs.loc.gov/audio/samplepacks/loc-fma/I-need-a-heroc-figure-main-character-theme_fma-158401_001_00-02-49.wav',
  ),
];