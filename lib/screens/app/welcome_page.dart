import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:highlandcoffeeapp/screens/app/introduce_page1.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    var d = const Duration(seconds: 5);
    Future.delayed(d, () {
      Get.offAll(() => const IntroducePage1());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColors,
      body: Center(
          child: Image.asset('assets/images/welcome-logo/highlands-coffee.jpg')),
    );
  }
}
