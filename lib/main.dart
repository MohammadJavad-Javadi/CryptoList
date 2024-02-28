import 'package:crypto_bazar/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Application());
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Sahel'),
      debugShowCheckedModeBanner: false,
      home: LoadScreen(),
    );
  }
}
