import 'package:flutter/material.dart';
import 'package:flutter_restaurant/content/waiters/AddWaiter.dart';
import 'package:flutter_restaurant/content/waiters/DeleteWaiter.dart';
import 'package:flutter_restaurant/models/waiters.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListWaiters extends StatefulWidget {
  @override
  State<ListWaiters> createState() => _ListWaitersState();
}

class _ListWaitersState extends State<ListWaiters> {
  late TextEditingController _controller;
  late String search;
  late Future<List<WaiterModel>> _listWaiters;

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
    _controller = TextEditingController();
    search = '';
    _listWaiters = getWaiters(search);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          color: Color.fromARGB(255, 27, 113, 243),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.white,
              ),
              Flexible(
                child: Container(
                  width: 200,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                      _listWaiters = getWaiters(search);
                    },
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Buscar',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) => AddWaiters(),
                  );
                },
                child: Icon(Icons.group_add),
              )
            ],
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 66, 66, 65),
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
    );
  }

  /// List waiters card
  List<Widget> listWaitersCard(List<WaiterModel> data) {
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
                  child: Text(element.name),
                ),
              ),
              Expanded(
                child: Center(
                  child: InkWell(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) => DeleteWaiter(
                          dialogContext,
                          element.id,
                          element.name,
                        ),
                      );
                      setState(() {
                        _listWaiters = getWaiters(search);
                      });
                    },
                    child: Icon(Icons.delete),
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
