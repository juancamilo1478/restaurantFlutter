import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class CreateSectorDialog extends StatefulWidget {
  @override
  _CreateSectorDialogState createState() => _CreateSectorDialogState();
}

class _CreateSectorDialogState extends State<CreateSectorDialog> {
  TextEditingController _x = TextEditingController();
  TextEditingController _y = TextEditingController();
  TextEditingController _name = TextEditingController();
  int _inputx = 0;
  int _inputy = 0;
  String _inputName = '';

  @override
  void dispose() {
    _x.dispose();
    _y.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Creando Sector"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Nombre: '),
              Expanded(
                child: Container(
                  width: 150,
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Nombre del sector'),
                    controller: _name,
                    onChanged: (value) {
                      setState(() {
                        _inputName = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Numero de mesas ancho: '),
              Expanded(
                child: Container(
                  width: 150,
                  child: TextField(
                    controller: _x,
                    decoration: InputDecoration(hintText: 'Maximo 8'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _inputx = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Numero de mesas alto: '),
              Expanded(
                child: Container(
                  width: 150, // Establece el ancho deseado para el TextField
                  child: TextField(
                    controller: _y,
                    decoration: InputDecoration(hintText: 'Maximo 8'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _inputy = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            print(_inputName);
            print(_inputx);
            print(_inputy);
            if (_inputName.isNotEmpty && _inputx != 0 && _inputy != 0) {
              final url = Uri.http('localhost:3001', '/sectors');

              final response = await http.post(
                url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'name': _inputName,
                  'x': _inputx,
                  'y': _inputy,
                }),
              );
            }
            Navigator.of(context).pop();
            // Acciones cuando se presiona "Sí"
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
}
