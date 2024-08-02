import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/views/temp_screen.dart';
import 'package:velocity_x/velocity_x.dart';


class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1 ;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assests/img/splash_pic.jpg',
            fit: BoxFit.cover,
              width: width * .9,
              height: height * .5,
            ),
            10.heightBox,
            Text(
              'Top News',
              style: GoogleFonts.anton(
                textStyle: TextStyle(
                  wordSpacing: 2.0,
                  letterSpacing: 4.0,
                  color: Colors.grey.shade700// Adjust letter spacing here
                ),
              ),
            ),
            60.heightBox,
            SpinKitChasingDots(color: Colors.black,size: 70,)
          ],
        ),
      ),
    );
  }
}