import 'package:flutter/material.dart';
import 'package:random_dice/asset/HomeScreen.dart';
import 'package:random_dice/const/SettingsScreen.dart';
import 'package:shake/shake.dart';
import 'dart:math';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller;
  double threshold = 2.7;
  int number = 1;
  ShakeDetector? shakeDetector;
  @override
  void initState(){
    super.initState();
    controller = TabController(length:2, vsync: this);
    controller!.addListener(tabListener);
    shakeDetector = ShakeDetector.autoStart(
        shakeSlopTimeMS: 100,
        shakeThresholdGravity: threshold,
        onPhoneShake: onPhoneShake,
    );
  }
  void onPhoneShake() {
    final rand = new Random();
    setState((){
      number = rand.nextInt(5) + 1;
    });
  }
  tabListener(){
    setState((){});
  }
  @override
  dispose(){
    controller!.removeListener(tabListener);
    shakeDetector!.stopListening();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: renderchildren(),
      ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }
  List<Widget> renderchildren() {
    return [
      HomeScreen(number: number),
      SettingsScreen(
          threshold: threshold,
          onThresholdChange: onThresholdChange,
      ),
    ];
  }
  void onThresholdChange(double val){
    setState(() {
      threshold = val;
    });
  }
  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
        currentIndex: controller!.index,
        onTap: (int index) {
          setState((){
            controller!.animateTo(index);
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.edgesensor_high_outlined,
              ),
              label: '주사위',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: '설정',
          ),
        ],
    );
  }
}