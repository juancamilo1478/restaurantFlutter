import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Widget DeleteWaiter(BuildContext context, int idWaiter, String nameWaiter) {
  String dialogue = '¿Seguro que quieres borrar el Sector $nameWaiter?';
  return AlertDialog(
    title: Row(
      children: [
        Icon(Icons.warning_amber),
        SizedBox(
          width: 20,
        ),
        Text(dialogue),
      ],
    ),
    content: Text(dialogue),
    actions: [
      TextButton(
        onPressed: () async {
          // Realizar la lógica para eliminar el producto
          final Uri url = Uri.parse('http://localhost:3001/waiter/$idWaiter');
          final response = await http.delete(url);
          if (response.statusCode == 201) {
            Navigator.of(context).pop();
          } else {
            print(response.body);
            Navigator.of(context).pop();
          }
        },
        child: Text('Sí'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('No'),
      ),
    ],
  );
}
