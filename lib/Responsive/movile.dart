import 'package:flutter/material.dart';
import 'package:flutter_restaurant/constant/constant.dart';
import 'package:flutter_restaurant/content/inventory/inventory.dart';

class movile extends StatefulWidget {
  const movile({super.key});

  @override
  State<movile> createState() => _movileState();
}

class _movileState extends State<movile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar,
      backgroundColor: myDefaultbackground,
      drawer: myDrawer,
      body: inventory(),
    );
  }
}
