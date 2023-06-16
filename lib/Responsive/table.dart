import 'package:flutter/material.dart';
import 'package:flutter_restaurant/constant/constant.dart';

class tables extends StatefulWidget {
  const tables({super.key});

  @override
  State<tables> createState() => _tablesState();
}

class _tablesState extends State<tables> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myDefaultbackground,
      appBar: myAppbar,
      drawer: myDrawer,
    );
  }
}
