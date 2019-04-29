import 'package:enrich/screens/Login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'CalibreMedium',
      ),
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
