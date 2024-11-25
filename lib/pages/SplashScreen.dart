import 'dart:async';
import 'dart:convert';

import 'package:code_sprout/singletons/LoggerSingleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  var adsInitilized=false;

  @override
  void initState() {
    MobileAds.instance.initialize().then((value) {
      if(!mounted) return;
      setState(()=>adsInitilized=true);
      if(timer!.isActive) return;
      LoggerSingleton().logger.i('Ads ${value.adapterStatuses.keys.join(',')} : ${value.adapterStatuses.values.join(',')}');
      goToHome();
    });
    timer=Timer(const Duration(seconds: 5),(){
      if(!mounted) return;
      if(adsInitilized) goToHome();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);

    return Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 75,vertical: 125),
              child:LottieBuilder.asset("assets/lottie/developer.json",fit: BoxFit.fitWidth,animate: true,backgroundLoading: true,),
            ),
            Column(
              children: [
                Text(
                  "Code Sprout",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "PermanentMarker", fontSize: 32, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 15),
                SpinKitPulse(color: theme.primaryColor)
              ],
            ),
          ],
        ));
  }

  goToHome(){
    GoRouter.of(context).replaceNamed('problems info');
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
