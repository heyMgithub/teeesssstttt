import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';

import 'ad_manager.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkTheme;
  final AdManager adManager;

  SettingsPage({required this.onThemeChanged, required this.isDarkTheme, required this.adManager});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isDarkTheme;

  @override
  void initState() {
    super.initState();
    isDarkTheme = widget.isDarkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Rate Us'),
            trailing: Icon(Icons.star),
            onTap: () {
              _showRateUsDialog(context);
            },
          ),
          ListTile(
            title: Text('Theme'),
            trailing: Icon(Icons.color_lens),
            onTap: () {
              _showThemeDialog(context);
            },
          ),
          ListTile(
            title: Text('Share'),
            trailing: Icon(Icons.share),
            onTap: () {
              Share.share('Check out this awesome music app!');
            },
          ),
          ListTile(
            title: Text('About Us'),
            trailing: Icon(Icons.info),
            onTap: () {
              _showAboutUsDialog(context);
            },
          ),
          AdManager().getBannerAdWidget()
        ],
      ),

    );
  }

  void _showRateUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rate Us'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please leave a rating:'),
              SizedBox(height: 16),
              _buildRatingStars(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final InAppReview inAppReview = InAppReview.instance;
                if (await inAppReview.isAvailable()) {
                  inAppReview.openStoreListing(
                    appStoreId: 'com.rachDev.chebbilal', // Replace with your actual app package name
                  );
                }
              },
              child: Text('Rate on Google Play'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRatingStars() {
    int rating = 0;
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.purple,
              ),
              onPressed: () {
                setState(() {
                  rating = index + 1;
                });
              },
            );
          }),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Light Theme'),
                onTap: () {
                  setState(() {
                    isDarkTheme = false;
                  });
                  widget.onThemeChanged(false);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Dark Theme'),
                onTap: () {
                  setState(() {
                    isDarkTheme = true;
                  });
                  widget.onThemeChanged(true);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('About Us'),
          content: Text(
              'Our team ensures that you enjoy your favorite songs and provides a great experience on our app. If you have a comment or inquiry, please feel free to leave us feedback to improve the quality of our services. Enjoy.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
