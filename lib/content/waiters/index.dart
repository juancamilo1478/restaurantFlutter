import 'package:flutter/material.dart';
import 'package:flutter_restaurant/content/waiters/listWaiters.dart';

class waiters extends StatefulWidget {
  const waiters({super.key});

  @override
  State<waiters> createState() => _waitersState();
}

class _waitersState extends State<waiters> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          ListWaiters(),
        ],
      ),
    );
  }
}
