import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ad_manager.g.dart';

@JsonSerializable()
class AdManager {
  final String? adNetwork;
  final String? interstitialAdmob;
  final String? bannerAdmob;
  final String? nativeAdmob;
  final String? interstitialFan;
  final String? bannerFan;
  final String? nativeFan;

  BannerAd? _bannerAd; // Changed to nullable type
  InterstitialAd? _interstitialAd; // Changed to nullable type
  bool _isBannerAdLoaded = false;
  bool _isInterstitialAdReady = false;

  AdManager({
    this.adNetwork,
    this.interstitialAdmob,
    this.bannerAdmob,
    this.nativeAdmob,
    this.interstitialFan,
    this.bannerFan,
    this.nativeFan,
  });

  factory AdManager.fromJson(Map<String, dynamic> json) => _$AdManagerFromJson(json);
  Map<String, dynamic> toJson() => _$AdManagerToJson(this);

  // Method to load banner ad
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: bannerAdmob ?? '', // Use provided ad unit ID or default
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isBannerAdLoaded = true;
          print('Banner ad loaded.');
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  // Method to get banner ad widget
  Widget getBannerAdWidget() {
    return _bannerAd == null
        ? SizedBox.shrink() // Return an empty widget if the ad is not loaded
        : AdWidget(ad: _bannerAd!); // Use the ad widget if it's loaded
  }

  // Method to load interstitial ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdmob ?? '', // Use provided ad unit ID or default
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          print('Interstitial ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  // Method to show interstitial ad
  void showInterstitialAd() {
    if (_isInterstitialAdReady) {
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          loadInterstitialAd(); // Load a new ad after the previous one is dismissed
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('Failed to show interstitial ad: $error');
          ad.dispose();
          loadInterstitialAd(); // Load a new ad after failure
        },
      );
      _interstitialAd?.show();
      _isInterstitialAdReady = false; // Reset the flag after showing the ad
    }
  }
}
