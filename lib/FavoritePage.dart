import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:testapi/song.dart';

import 'PlayerPage.dart';
import 'ad_manager.dart';

class FavoritePage extends StatelessWidget {
  final List<Song> favoriteSongs;
  final Function(Song) onFavoriteToggle;
  final AdManager adManager;

  FavoritePage({
    required this.favoriteSongs,
    required this.onFavoriteToggle,
    required this.adManager,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: AdManager().getBannerAdWidget(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favoriteSongs.length,
              itemBuilder: (context, index) {
                Song song = favoriteSongs[index];
                return ListTile(
                  leading: song.image != null
                      ? Image.network(
                    song.image!,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  )
                      : Icon(Icons.image_not_supported),
                  title: Text(song.songName ?? 'Unknown'),
                  subtitle: Text(song.artist ?? 'Unknown'),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.purple,
                    ),
                    onPressed: () => onFavoriteToggle(song),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerPage(
                          songs: favoriteSongs,
                          initialIndex: index,
                          favoriteSongs: favoriteSongs,
                          onFavoriteToggle: onFavoriteToggle,
                          adManager: adManager, // Pass AdManager to PlayerPage
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
