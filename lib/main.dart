import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:testapi/data.dart';
import 'package:testapi/song.dart';
import 'package:http/http.dart' as http;

import 'FavoritePage.dart';
import 'PlayerPage.dart';
import 'SettingsPage.dart';
import 'ad_manager.dart'; // Import AdManager

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'aghani cheb bilal',
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: SplashScreen(onThemeChanged: (bool value) {
        setState(() {
          isDarkTheme = value;
        });
      }),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  SplashScreen({required this.onThemeChanged});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(onThemeChanged: widget.onThemeChanged)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bc.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                'CHEB BILAL',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.purple,
                      offset: Offset(7.0, 7.0),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/images/bilal.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Text(
                'M U S I C',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.purple,
                      offset: Offset(7.0, 7.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final Function(bool) onThemeChanged;

  MainPage({required this.onThemeChanged});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late PageController _pageController;
  List<Song> _favoriteSongs = [];
  final AdManager _adManager = AdManager(); // Initialize AdManager

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _adManager.loadInterstitialAd(); // Load interstitial ad for transitions
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
    _adManager.showInterstitialAd(); // Show interstitial ad on tab change
  }

  void _toggleFavorite(Song song) {
    setState(() {
      if (_favoriteSongs.contains(song)) {
        _favoriteSongs.remove(song);
      } else {
        _favoriteSongs.add(song);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomePage(
            favoriteSongs: _favoriteSongs,
            onFavoriteToggle: _toggleFavorite,
            adManager: _adManager, // Pass AdManager to HomePage
          ),
          FavoritePage(
            favoriteSongs: _favoriteSongs,
            onFavoriteToggle: _toggleFavorite,
            adManager: _adManager, // Pass AdManager to FavoritePage
          ),
          SettingsPage(onThemeChanged: widget.onThemeChanged, isDarkTheme: false, adManager: _adManager), // Pass AdManager to SettingsPage
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.purple[300],
        onTap: _onItemTapped,
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Song> favoriteSongs;
  final Function(Song) onFavoriteToggle;
  final AdManager adManager; // Add AdManager

  HomePage({required this.favoriteSongs, required this.onFavoriteToggle, required this.adManager}); // Add AdManager to constructor

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Data> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<Data> fetchData() async {
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/MenRiko/chab-billal/main/bilal.json'));

    if (response.statusCode == 200) {
      return Data.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  bool isFavorite(Song song) {
    return widget.favoriteSongs.contains(song);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cheb Bilal Songs', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: AdManager().getBannerAdWidget(),
          ),
          Expanded(
            child: FutureBuilder<Data>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.songs == null || snapshot.data!.songs!.isEmpty) {
                  return Center(child: Text('No songs found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.songs!.length,
                    itemBuilder: (context, index) {
                      Song song = snapshot.data!.songs![index];
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
                            isFavorite(song) ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite(song) ? Colors.purple : null,
                          ),
                          onPressed: () => widget.onFavoriteToggle(song),
                        ),
                        onTap: () {
                          widget.adManager.showInterstitialAd(); // Show ad on song tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerPage(
                                songs: snapshot.data!.songs!,
                                initialIndex: index,
                                favoriteSongs: widget.favoriteSongs,
                                onFavoriteToggle: widget.onFavoriteToggle,
                                adManager: widget.adManager, // Pass AdManager to PlayerPage
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
