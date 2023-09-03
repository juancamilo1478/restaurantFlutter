import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Widget deleteProductAccount(
    BuildContext context, String nameProduct, String idProduct, int idAccount) {
  String dialogue = '¿Seguro que quieres borrar el producto $nameProduct?';

  return AlertDialog(
    title: Row(
      children: [
        Icon(Icons.warning_amber),
        SizedBox(
          width: 20,
        ),
        Text('Alerta')
      ],
    ),
    content: Text(dialogue),
    actions: [
      TextButton(
        onPressed: () async {
          // Realizar la lógica para eliminar el producto

          final url = Uri.http('localhost:3001', '/accounts/delete');

          final response = await http.delete(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'accountId': idAccount,
              'productId': idProduct,
            }),
          );
          if (response.statusCode == 200) {
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
