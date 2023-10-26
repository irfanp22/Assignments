import 'package:flutter/material.dart';
import 'package:responsi1_b2/ui/assignment_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Assignments',
      debugShowCheckedModeBanner: false,
      home: TaskPage(),
    );
  }
}
