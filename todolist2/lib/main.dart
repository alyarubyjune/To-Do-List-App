import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'input_provider.dart';
import 'home_page.dart';

class ToDoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(int.parse('0xd1e693')).withOpacity(1.0),
      ),
      home: HomePage(),
    );
  }
}

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => InputProvider(),
    child: ToDoListApp(),
  ));
}
