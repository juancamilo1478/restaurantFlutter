import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddWaiters extends StatefulWidget {
  const AddWaiters({super.key});

  @override
  State<AddWaiters> createState() => _AddWaitersState();
}

class _AddWaitersState extends State<AddWaiters> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.person_add),
          SizedBox(
            width: 10,
          ),
          Text('Agregando mecero')
        ],
      ),
    );
  }
}
