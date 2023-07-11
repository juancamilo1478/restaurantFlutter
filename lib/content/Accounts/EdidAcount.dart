import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditDialog extends StatefulWidget {
  final int initialQuantity;
  final String nameProduct;
  final int idAccount;
  final int idProduct;
  const EditDialog(
      {Key? key,
      required this.initialQuantity,
      required this.nameProduct,
      required this.idAccount,
      required this.idProduct})
      : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late int quantity;
  TextEditingController _quantityController = TextEditingController();
  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
    _quantityController = TextEditingController(text: quantity.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.nameProduct} cantidad'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            maxLength: 3,
            controller: _quantityController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
            ],
            onChanged: (value) {
              try {
                quantity = int.parse(value);
              } catch (e) {
                // Manejar el error de conversión si es necesario
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              final url = Uri.http('localhost:3001', '/accounts/product');
              final response = await http.put(
                url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'accountId': widget.idAccount,
                  'productId': widget.idProduct,
                  'quantity': quantity,
                }),
              );

              if (response.statusCode == 201) {
                print('ok');
                Navigator.of(context).pop();
              } else {
                print(response.body);
                Navigator.of(context).pop();
              }
            },
            child: Text('Guardar'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}
