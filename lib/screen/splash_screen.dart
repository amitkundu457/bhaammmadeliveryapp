import 'dart:async';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/default_colors.dart';
import '../utils/image_constant.dart';
import '../widgets/custom_image_view.dart';
import 'auth/login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate splash delay
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('login_token');

    if (token != null && token.isNotEmpty) {
      _navigateTo(const HomeScreen());
    } else {
      _navigateTo(const LoginScreen());
    }
  }
  void _navigateTo(Widget page) {
    Navigator.pushReplacement(
      context,
      PageTransition(
        duration: const Duration(milliseconds: 250),
        reverseDuration: const Duration(milliseconds: 250),
        type: PageTransitionType.fade,
        child: page,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultColor.mainColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: 170, // ya minRadius / maxRadius bhi chalega
              backgroundColor: DefaultColor.mainColor,
              child: ClipOval(
                child: Image.asset(
                  "${ImageConstant.logo}",
                  width: 170, // ✅ Width control
                  height: 250, // ✅ Height control
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text("BHAAMMA",style: TextStyle(color: Colors.white,fontSize: 27,fontWeight: FontWeight.bold),),
          Text("RIDER",style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
