import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class EditInventoryDialog extends StatefulWidget {
  final String productId;
  final String productName;
  final String productType;
  final String productPrice;
  final String productStore;

  //selector type

  const EditInventoryDialog({
    required this.productId,
    required this.productName,
    required this.productType,
    required this.productPrice,
    required this.productStore,
  });

  @override
  _EditInventoryDialogState createState() => _EditInventoryDialogState();
}

class _EditInventoryDialogState extends State<EditInventoryDialog> {
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _store = TextEditingController();

  String? _inputName;
  String? _inputPrice;
  String? _inputStore;
  String? _Selection;

  @override
  void initState() {
    super.initState();
    _name.text = widget.productName;
    _price.text = widget.productPrice;
    _store.text = widget.productStore;
    _Selection = widget.productType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Editar Producto"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Nombre'),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _name,
                  onChanged: (value) {
                    setState(() {
                      _inputName = value;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Precio'),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _price,
                  onChanged: (value) {
                    setState(() {
                      _inputPrice = value;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Inventario'),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _store,
                  onChanged: (value) {
                    setState(() {
                      _inputStore = value;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Categoria'),
              SizedBox(
                width: 10,
              ),
              DropdownButton(
                  hint: Text('Seleccionar categoria'),
                  value: _Selection,
                  items: [
                    DropdownMenuItem(
                      value: 'Restaurant',
                      child: Text('Restaurante'),
                    ),
                    DropdownMenuItem(
                      value: 'Sweet',
                      child: Text('dulces'),
                    ),
                    DropdownMenuItem(
                      value: 'IceCream',
                      child: Text('Helados'),
                    ),
                    DropdownMenuItem(
                      value: 'Other',
                      child: Text('Otros'),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _Selection = value;
                    });
                  }),
            ],
          )
          // Add other fields as needed
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final url =
                Uri.http('localhost:3001', '/products/${widget.productId}');

            final response = await http.put(
              url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'name': _inputName ?? widget.productName,
                'type': _Selection ?? widget.productType,
                'price': _inputPrice ?? widget.productPrice,
                'store': _inputStore ?? widget.productStore,
              }),
            );

            if (response.statusCode == 200) {
              messageFinish();
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Text('Cambiar'),
        ),
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

void messageFinish() {
  Fluttertoast.showToast(msg: 'producto cambiado', fontSize: 18);
}
