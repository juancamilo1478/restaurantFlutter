import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class AddNewProduct extends StatefulWidget {
  @override
  _EditInventoryDialogState createState() => _EditInventoryDialogState();
}

class _EditInventoryDialogState extends State<AddNewProduct> {
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _store = TextEditingController();

  String? _inputName;
  String? _inputPrice;
  String? _inputStore;
  String? _Selection;
  bool? _state;
  String? _error;
  @override
  void initState() {
    super.initState();
    _Selection = 'Restaurant';
    _state = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Nuevo Producto"),
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
            if (_Selection != null &&
                _inputName != null &&
                _inputPrice != null &&
                _inputStore != null) {
              final url = Uri.http('localhost:3001', '/products');

              final response = await http.post(
                url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'name': _inputName,
                  'type': _Selection ?? 'widget.productType',
                  'price': _inputPrice ?? 0,
                  'store': _inputStore ?? 0,
                }),
              );
              if (response.statusCode == 201) {
                Navigator.of(context).pop();
              }
            } else {
              setState(() {
                _error = "Faltan datos";
              });
            }
          },
          child: Text('Crear'),
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
