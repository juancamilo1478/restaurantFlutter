import 'package:flutter/material.dart';
import 'package:flutter_restaurant/Responsive/deskatop.dart';
import 'package:flutter_restaurant/Responsive/movile.dart';
import 'package:flutter_restaurant/Responsive/responsivelayaut.dart';
import 'package:flutter_restaurant/Responsive/table.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: layout(
        mobilScaffold: const movile(),
        desktopScaffold: const Deskatop(),
        tablesScafold: const tables(),
      ),
    );
  }
}
