import 'package:code_sprout/singletons/LoggerSingleton.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdd extends StatefulWidget {
  const InterstitialAdd({super.key});

  @override
  State<InterstitialAdd> createState() => _InterstitialAddState();
}

class _InterstitialAddState extends State<InterstitialAdd> {
  @override
  void initState() {
    _loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  void _loadAd() {
    final interstitialAd = InterstitialAd.load(
      adUnitId: 'ca-app-pub-4715945578201106/8253610758',
      request: const AdRequest(keywords: ['gfg','geeksforgeeks','leetcode','codingninja','codechef','codeforces','naukri']),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
        ad.show();
      }, onAdFailedToLoad: (error) {
        LoggerSingleton().logger.e('Interstitial ad failed to load: $error');
      },)
    );
  }
}