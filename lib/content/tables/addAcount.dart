import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/waiters.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddAccount extends StatefulWidget {
  final int idTable;

  const AddAccount({
    required this.idTable,
  });
  @override
  _AddAccountState createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  Future<List<WaiterModel>>? _listWaiters;
  TextEditingController _nameController = TextEditingController();

  String? _search;

  Future<List<WaiterModel>> getWaiters(String searchWaiter) async {
    final Uri url =
        Uri.parse('http://localhost:3001/waiter?name=$searchWaiter');
    final response = await http.get(url);
    final List<WaiterModel> _waiters = [];
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      for (var item in jsonData) {
        _waiters.add(WaiterModel(item['id'], item['name'], item['photo']));
      }
    } else {
      throw Exception("Fallo la petición");
    }

    return _waiters;
  }

  @override
  void initState() {
    super.initState();
    _search = '';
    _listWaiters = getWaiters(_search ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Selecciona el mesero'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.search),
              Container(
                width: 200,
                child: TextField(
                  maxLength: 40,
                  controller: _nameController,
                  onChanged: (value) {
                    setState(() {
                      _search = value;
                      _listWaiters = getWaiters(_search ?? '');
                    });
                  },
                ),
              ),
            ],
          ),
          Container(
            height: 400,
            width: 400,
            child: FutureBuilder<List<WaiterModel>>(
              future: _listWaiters,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    children: listWaitersCard(snapshot.data!),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error al obtener los datos");
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            // Realizar alguna acción con el valor seleccionado
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  List<Widget> listWaitersCard(List<WaiterModel> data) {
    Future<void> createAccount(int idWaiter) async {
      final url = Uri.http('localhost:3001', '/accounts');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'tableId': widget.idTable, 'waiterId': idWaiter}),
      );
      try {
        if (response.statusCode == 201) {
          print('Archivo cargado exitosamente');
          // Manejar la respuesta del servidor
          Navigator.of(context).pop();
        } else {
          print(
              'Error al cargar el archivo. Código de estado: ${response.statusCode}');
          // Manejar el error
        }
      } catch (error) {
        print('Error desconocido: $error');
        // Manejar el error
      }
    }

    List<Widget> _waiters = [];
    for (var element in data) {
      _waiters.add(
        Card(
          key: Key(element.id.toString()),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                child: Image.network(
                  element.photo,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(element.name),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          createAccount(element.id);
                        },
                        child: Icon(
                          Icons.group_add_rounded,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return _waiters;
  }
}
