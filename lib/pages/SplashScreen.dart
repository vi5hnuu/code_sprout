import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  String? error;

  @override
  void initState() {
    timer=Timer(const Duration(seconds: 5),()=>goToHome());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                Text(
                  error ?? "Initializing...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "PermanentMarker", fontSize: 18, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                )
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
