import 'package:flutter/material.dart';
import 'package:flutter_restaurant/content/tables/tablesList.dart';

class Tables extends StatefulWidget {
  const Tables({super.key});

  @override
  State<Tables> createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          datasTables(),
        ],
      ),
    );
  }
}
