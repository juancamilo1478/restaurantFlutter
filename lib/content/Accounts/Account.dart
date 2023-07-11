import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_restaurant/content/Accounts/AddProductAccount.dart';
import 'package:flutter_restaurant/models/Account.dart';
import 'package:flutter_restaurant/models/waiters.dart';
import 'package:flutter_restaurant/services/printAccount.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountScreen extends StatefulWidget {
  final int accountId;
  final String nameTable;
  const AccountScreen({
    required this.accountId,
    required this.nameTable,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<AccountModel> accountTable;
  late Future<WaiterModel> _Waiter;
  String direction = '';
  Future<AccountModel> getAccount(int idAccount) async {
    final Uri url =
        Uri.parse('http://localhost:3001/accounts/product/$idAccount');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List<dynamic> productsData = jsonData['Products'];
      final List<ProductAccount> products = [];

      for (var productData in productsData) {
        final product = ProductAccount(
          id: productData['id'],
          type: productData['type'],
          name: productData['name'],
          price: productData['price'],
          photo: productData['photo'],
          store: productData['store'],
          quantity: productData['AccountProducts']['quantity'],
        );
        products.add(product);
      }

      final account = AccountModel(
        id: jsonData['id'],
        total: jsonData['total'].toString(),
        date: jsonData['date'].toString(),
        state: jsonData['state'].toString(),
        propine: jsonData['propine'].toString(),
        waitersId: jsonData['WaitersId'],
        tableId: jsonData['TableId'],
        products: products,
      );

      return account;
    } else {
      throw Exception("Fallo la petición");
    }
  }

  Future<WaiterModel> getWaiter(int idwaiter) async {
    final Uri url = Uri.parse('http://localhost:3001/waiter/$idwaiter');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final waiter = WaiterModel(
        jsonData['id'],
        jsonData['name'].toString(),
        jsonData['photo'].toString(),
      );

      return waiter;
    } else {
      throw Exception("Fallo la petición");
    }
  }

  @override
  void initState() {
    accountTable = getAccount(widget.accountId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AccountModel>(
      future: accountTable,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AlertDialog(
            title: Text('Cuenta'),
            content: CircularProgressIndicator(),
            actions: [
              TextButton(
                child: Text('cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: Text('Cuenta'),
            content: Text('Error: ${snapshot.error}'),
            actions: [
              TextButton(
                child: Text('cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          final account = snapshot.data;

          _Waiter = getWaiter(account!.waitersId);

          return AlertDialog(
            title: Row(
              children: [
                Column(
                  children: [
                    Text(
                      widget.nameTable,
                      style: TextStyle(fontSize: 15),
                    ),
                    Text('No.${widget.accountId.toString()}  ',
                        style: TextStyle(fontSize: 15)),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Text('agregar Productos  '),
                InkWell(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          FutureBuilder<AccountModel>(
                        future: accountTable,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Error: ${snapshot.error}'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            );
                          } else {
                            final account = snapshot.data;

                            return addProductAccount(idAccount: account!.id);
                          }
                        },
                      ),
                    );
                    setState(() {
                      accountTable = getAccount(widget.accountId);
                    });
                  },
                  child: Icon(
                    Icons.add_circle_outline_outlined,
                    size: 20,
                  ),
                ),
                FutureBuilder<WaiterModel>(
                    future: _Waiter,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('error');
                      } else {
                        final waiterdata = snapshot.data;

                        return waiterAccount(waiterdata: waiterdata!);
                      }
                    })
              ],
            ),
            content: DataTable(
              columns: [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Cantidad')),
                DataColumn(label: Text(' Precio')),
                DataColumn(label: Text('total')),
                DataColumn(label: Text('Borrar')),
              ],
              rows: _products(account!.products),
            ),
            actions: [
              ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.print_outlined),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Imprimir '),
                  ],
                ),
                onPressed: () {
                  // String? direction = await selectFolder();

                  printAccount(context);
                },
              ),
              TextButton(
                child: Text('cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }

  List<DataRow> _products(List<ProductAccount> products) {
    int _total = 0;
    final List<DataRow> rows = products.map((product) {
      _total = _total + (product.price * product.quantity);
      return DataRow(
        cells: [
          DataCell(Text(product.name)),
          DataCell(
            Row(
              children: [
                Text(product.quantity.toString()),
                SizedBox(width: 5),
                InkWell(
                  onTap: () async {
                    // Lógica para editar el producto
                  },
                  child: Icon(Icons.edit, size: 20),
                ),
              ],
            ),
          ),
          DataCell(Text(product.price.toString())),
          DataCell(Text((product.price * product.quantity).toString())),
          DataCell(
            InkWell(
              onTap: () async {
                // Lógica para editar el elemento
              },
              child: Icon(Icons.disabled_by_default_outlined),
            ),
          ),
        ],
      );
    }).toList();

    // Agregar fila adicional al final del mapa
    rows.add(
      DataRow(
        cells: [
          DataCell(Text('')),
          DataCell(Text('')),
          DataCell(Text('Total:')),
          DataCell(Text(_total.toString())),
          DataCell(Text('')),
        ],
      ),
    );

    return rows;
  }
}

//waiter datas
class waiterAccount extends StatefulWidget {
  final WaiterModel waiterdata;

  const waiterAccount({
    required this.waiterdata,
  });

  @override
  State<waiterAccount> createState() => _waiterAccountState();
}

class _waiterAccountState extends State<waiterAccount> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 60,
            height: 60,
            child: Image.network(
              widget.waiterdata.photo,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            widget.waiterdata.name,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

Future<String?> selectFolder() async {
  String? folderPath = await FilePicker.platform.getDirectoryPath();
  if (folderPath != null) {
    return folderPath;
  } else {
    return null;
  }
}
