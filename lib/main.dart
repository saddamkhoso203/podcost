 import 'package:flutter/material.dart';

import 'view/screens/podcost_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
   => MaterialApp(

      debugShowCheckedModeBanner: false,
      color: Colors.blue,
      home: PodcostScreen(),
    );
  }
