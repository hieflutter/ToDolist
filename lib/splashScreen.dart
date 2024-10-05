import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todolist/Responsiv.dart';
import 'package:todolist/ScreenSizeConfig.dart';
import 'package:todolist/ax.dart';
import 'package:todolist/home.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  Widget build(BuildContext context) {
    ScreenSizeConfig.init(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  'animation/screen.json',
                  height: 400,
                  width: 300,
                ),
                SizedBox(height: height / 80),
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Make Your Day',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (Responsive.isMobile(context)
                                ? ScreenSizeConfig.ScreenWidth * 0.05
                                : ScreenSizeConfig.ScreenWidth * 0.06),
                          ),
                        ),
                      ]),
                )
              ],
            )));
  }
}
