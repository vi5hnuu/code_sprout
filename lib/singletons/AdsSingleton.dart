import 'dart:async';
import 'dart:io';

import 'package:code_sprout/singletons/LoggerSingleton.dart';
import 'package:dio/dio.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdEvent{}
class LoadInterstitialAd extends AdEvent{}

class AdsSingleton {
  final StreamController<AdEvent> _interStitialAd;
  static final AdsSingleton _instance = AdsSingleton._();

  AdsSingleton._():_interStitialAd=StreamController<AdEvent>(){
   _interStitialAd.stream.listen((event) {
    if(event is LoadInterstitialAd) _loadInterstitialAd();
   });
  }

  _loadInterstitialAd(){
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-4715945578201106/8253610758',
        request: const AdRequest(keywords: ['gfg','geeksforgeeks','leetcode','codingninja','codechef','codeforces','naukri']),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          ad.show();
        }, onAdFailedToLoad: (error) {
          LoggerSingleton().logger.e('Interstitial ad failed to load: $error');
        },)
    );
  }

  void dispatch(AdEvent event){
    _interStitialAd.sink.add(event);
  }

  factory AdsSingleton() {
    return _instance;
  }
}
