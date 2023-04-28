import 'package:flutter/material.dart';
import 'package:online_food_ordering_web/screens/home/home_screen.dart';
import 'package:online_food_ordering_web/screens/home/shopping_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assiat sweet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: const SoppingScreen(),
    );
  }
}
