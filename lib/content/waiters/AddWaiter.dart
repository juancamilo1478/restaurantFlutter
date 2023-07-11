import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/services/select_image.dart';
import 'package:http/http.dart' as http;

class AddWaiters extends StatefulWidget {
  const AddWaiters({super.key});

  @override
  State<AddWaiters> createState() => _AddWaitersState();
}

class _AddWaitersState extends State<AddWaiters> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();
  TextEditingController _cedulecontroller = TextEditingController();
  TextEditingController _epscontroller = TextEditingController();
  TextEditingController _directioncontroller = TextEditingController();
  String? _phone;
  String? _name;
  String? _eps;
  String? _cedule;
  String? _direction;
  String? _selectCategorie = 'Waiter';
  File? imagen_upload;

  Future<void> createWaiter() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://localhost:3001/waiter'), // Reemplaza la URL con tu URL de servidor
    );

    var file = await http.MultipartFile.fromBytes(
      'myFile',
      await File(imagen_upload!.path)
          .readAsBytes(), // Utiliza el método readAsBytes para obtener los bytes del archivo
      filename: imagen_upload!.path
          .split('/')
          .last, // Proporciona el nombre del archivo
    );

    request.fields['name'] = _name!;
    request.fields['categorie'] = _selectCategorie!;
    request.fields['cedule'] = _cedule!;
    request.fields['eps'] = _eps!;
    request.fields['phone'] = _phone!;
    request.fields['direction'] = _direction!;

    // Reemplaza 'John Doe' con el nombre que deseas enviar
    request.files.add(file);

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        print('Archivo cargado exitosamente');
        // Manejar la respuesta del servidor
        Navigator.of(context).pop();
      } else {
        print(response);
        // Manejar el error
      }
    } catch (error) {
      print('Error desconocido: $error');
      // Manejar el error
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SingleChildScrollView(
        child: Row(
          children: [
            Icon(Icons.person_add),
            SizedBox(
              width: 10,
            ),
            Text('Agregando mesero')
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Nombre'),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 200,
                child: TextField(
                  controller: _nameController,
                  maxLength: 40,
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              Text('Cedula'),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 200,
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: _cedulecontroller,
                  maxLength: 15,
                  onChanged: (value) {
                    setState(() {
                      _cedule = value;
                    });
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              Text('Direccion'),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 200,
                child: TextField(
                  controller: _directioncontroller,
                  maxLength: 40,
                  onChanged: (value) {
                    setState(() {
                      _direction = value;
                    });
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              Text('Celular'),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 200,
                child: TextField(
                  controller: _phonecontroller,
                  maxLength: 15,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              Text('Eps'),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 200,
                child: TextField(
                  controller: _epscontroller,
                  maxLength: 40,
                  onChanged: (value) {
                    setState(() {
                      _eps = value;
                    });
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              Text('Categoria'),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 200,
                child: DropdownButton<String>(
                  value: _selectCategorie,
                  items: [
                    DropdownMenuItem(
                      value: 'Waiter',
                      child: Text('Mesero'),
                    ),
                    DropdownMenuItem(
                      value: 'lifeJacket',
                      child: Text('Salvavidas'),
                    ),
                    DropdownMenuItem(
                      value: 'chef',
                      child: Text('Cocina'),
                    ),
                    DropdownMenuItem(
                      value: 'checker',
                      child: Text('Caja'),
                    ),
                    DropdownMenuItem(
                      value: 'other',
                      child: Text('otros'),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _selectCategorie = value!;
                    });
                  },
                ),
              )
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                final imagen = await getImage();

                setState(() {
                  imagen_upload = File(imagen!.path);
                });
              },
              child: Text('Subir imagen')),
          imagen_upload != null ? Image.file(imagen_upload!) : Container()
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (imagen_upload != null && _name != '') {
              createWaiter();
            }
          },
          child: Text('Agregar'),
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
