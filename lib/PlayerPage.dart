import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:testapi/song.dart';
import 'dart:math';
import 'ad_manager.dart';

class PlayerPage extends StatefulWidget {
  final List<Song> songs;
  final int initialIndex;
  final List<Song> favoriteSongs;
  final Function(Song) onFavoriteToggle;
  final AdManager adManager;

  PlayerPage({
    required this.songs,
    required this.initialIndex,
    required this.favoriteSongs,
    required this.onFavoriteToggle,
    required this.adManager,
  });

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AdManager _adManager;
  bool isPlaying = false;
  bool isFavorite = false;
  bool isRepeating = false;
  int currentIndex = 0;
  late AnimationController _animationController;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Initialize and load ads
    _adManager = AdManager(); // Initialize with necessary ad unit IDs
    _adManager.loadBannerAd();
    _adManager.loadInterstitialAd();

    currentIndex = widget.initialIndex;
    isFavorite = widget.favoriteSongs.contains(widget.songs[currentIndex]);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (isRepeating) {
        playSong(widget.songs[currentIndex]);
      } else {
        setState(() {
          isPlaying = false;
          _animationController.stop();
        });
      }
    });

    playSong(widget.songs[currentIndex]);
  }

  void playSong(Song song) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(song.songLink!));
    setState(() {
      isPlaying = true;
      _animationController.repeat(reverse: true);
    });
  }

  void pauseSong() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
      _animationController.stop();
    });
  }

  void resumeSong() async {
    await _audioPlayer.resume();
    setState(() {
      isPlaying = true;
      _animationController.repeat(reverse: true);
    });
  }

  void playNextSong() {
    if (currentIndex < widget.songs.length - 1) {
      currentIndex++;
      playSong(widget.songs[currentIndex]);
    } else {
      _audioPlayer.stop();
      setState(() {
        isPlaying = false;
        _animationController.stop();
      });
    }
    setState(() {
      isFavorite = widget.favoriteSongs.contains(widget.songs[currentIndex]);
    });
  }

  void playPreviousSong() {
    if (currentIndex > 0) {
      currentIndex--;
      playSong(widget.songs[currentIndex]);
    } else {
      _audioPlayer.stop();
      setState(() {
        isPlaying = false;
        _animationController.stop();
      });
    }
    setState(() {
      isFavorite = widget.favoriteSongs.contains(widget.songs[currentIndex]);
    });
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      widget.onFavoriteToggle(widget.songs[currentIndex]);
    });
  }

  void toggleRepeat() {
    setState(() {
      isRepeating = !isRepeating;
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Song currentSong = widget.songs[currentIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            _adManager.showInterstitialAd(); // Show interstitial ad on pop
          },
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/bilal.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              currentSong.songName ?? 'Unknown',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            Text(
              currentSong.artist ?? 'Unknown Artist',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 30),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        width: 10,
                        height: 10 + 20 * sin((_animationController.value + index / 5) * pi).abs(),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  color: Colors.deepPurple,
                  iconSize: 36,
                  onPressed: () {
                    toggleFavorite();
                  },
                ),
                SizedBox(width: 60),
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  color: Colors.deepPurple,
                  iconSize: 36,
                  onPressed: () {
                    playPreviousSong();
                  },
                ),
                IconButton(
                  icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                  color: Colors.deepPurple,
                  iconSize: 48,
                  onPressed: () {
                    if (isPlaying) {
                      pauseSong();
                    } else {
                      resumeSong();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  color: Colors.deepPurple,
                  iconSize: 36,
                  onPressed: () {
                    playNextSong();
                  },
                ),
                SizedBox(width: 60),
                IconButton(
                  icon: Icon(isRepeating ? Icons.repeat_one : Icons.repeat),
                  color: Colors.deepPurple,
                  iconSize: 36,
                  onPressed: () {
                    toggleRepeat();
                  },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
