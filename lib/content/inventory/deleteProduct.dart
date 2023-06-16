import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

Widget showDeleteProductDialog(
    BuildContext context, int productId, String productName) {
  String dialogue = '¿Seguro que quieres borrar el producto $productName?';

  return AlertDialog(
    title: Text("Alerta"),
    content: Text(dialogue),
    actions: [
      TextButton(
        onPressed: () async {
          // Realizar la lógica para eliminar el producto
          final Uri url =
              Uri.parse('http://localhost:3001/products/$productId');
          final response = await http.delete(url);
          if (response.statusCode == 201) {
            Fluttertoast.showToast(
              msg: '$productName fue eliminado correctamente',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              timeInSecForIosWeb: 2,
            );
            Navigator.of(context).pop();
          } else {
            Fluttertoast.showToast(
              msg: 'Error',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              timeInSecForIosWeb: 2,
            );
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
