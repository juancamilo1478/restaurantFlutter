import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/content/Accounts/AddProductAccount.dart';
import 'package:flutter_restaurant/content/Accounts/AlertMensaje.dart';
import 'package:flutter_restaurant/content/Accounts/DeleteProductAcount.dart';
import 'package:flutter_restaurant/content/Accounts/EdidAcount.dart';
import 'package:flutter_restaurant/content/Accounts/kitchen.dart';
import 'package:flutter_restaurant/content/Accounts/pay.dart';
import 'package:flutter_restaurant/models/Account.dart';
import 'package:flutter_restaurant/models/waiters.dart';
import 'package:flutter_restaurant/services/CancelAccount.dart';
import 'package:flutter_restaurant/services/FinishAccount.dart';
import 'package:flutter_restaurant/services/printAccount.dart';
import 'package:flutter_restaurant/services/printkitchen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountScreen extends StatefulWidget {
  final int accountId;
  final String nameTable;
  final String nameSector;
  const AccountScreen(
      {required this.accountId,
      required this.nameTable,
      required this.nameSector});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<AccountModel> accountTable;
  late Future<WaiterModel> _Waiter;
  String direction = '';
  num _total = 0;
  num propine = 0;
  num totalAddPropine = 0;
  TextEditingController propineController =
      TextEditingController(text: (0).toString());
  num percent = 0;
  TextEditingController percentController =
      TextEditingController(text: 0.toString());
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

          return SingleChildScrollView(
            child: AlertDialog(
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
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      final account = await showDialog(
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
                      size: 40,
                      color: Colors.green,
                    ),
                  ),
                  FutureBuilder<WaiterModel>(
                      future: _Waiter,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Cambia el color aquí
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete_forever_sharp),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Anular'),
                    ],
                  ),
                  onPressed: () async {
                    print(account.tableId);
                    final Result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ALertMensaje(
                                initialValue:
                                    "Estas seguro de Borrar esta cuenta")));

                    if (Result == true) {
                      final canceledResult = await CanceledAccount(
                          widget.accountId, account.tableId);
                      if (canceledResult == 'Cuenta cancelada con éxito.') {
                        Navigator.of(context).pop();
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Error "),
                                content: Text(canceledResult),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Ok"),
                                  ),
                                ],
                              );
                            });
                      }
                    }
                  },
                ),
                ElevatedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fastfood_outlined),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Cocina'),
                    ],
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => kitchen(data: account.products),
                      ),
                    );
                    final waiter = await getWaiter(account.waitersId);
                    printKitchen(
                      context,
                      result,
                      widget.nameTable,
                      widget.nameSector,
                      waiter,
                    );
                  },
                ),
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
                    printAccount(context, account, percent, widget.nameSector,
                        widget.accountId, widget.nameTable);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.monetization_on_outlined),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Pago'),
                    ],
                  ),
                  onPressed: () async {
                    final Result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              pay(total: _total, propine: propine.toInt()),
                        ));
                    final stateFinish = await finishAccount(
                      widget.accountId,
                      account.tableId,
                      Result['box'] ?? 0,
                      Result['card'] ?? 0,
                      Result['propine'] ?? 0,
                    );
                    if (stateFinish == 'Completado') {
                      Navigator.of(context).pop();
                    } else {
                      print("error");
                    }
                  },
                ),
                TextButton(
                  child: Text('cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  List<DataRow> _products(List<ProductAccount> products) {
    final List<DataRow> rows = products.map((product) {
      _total = 0;
      totalAddPropine = 0;
      for (var data in products) {
        _total = (data.price * data.quantity) + _total;
      }

      initState() {
        propineController.text = (_total * (percent / 100)).toString();
      }

      totalAddPropine = (_total * (percent / 100)) + _total;
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EditDialog(
                          initialQuantity: product.quantity,
                          nameProduct: product.name,
                          idAccount: widget.accountId,
                          idProduct: product.id,
                        );
                      },
                    ).then((value) {
                      setState(() {
                        accountTable = getAccount(widget.accountId);
                      });
                    });
                  },
                  child: Icon(Icons.edit, size: 20),
                )
              ],
            ),
          ),
          DataCell(Text(product.price.toString())),
          DataCell(Text((product.price * product.quantity).toString())),
          DataCell(
            InkWell(
              onTap: () async {
                // Lógica para editar el elemento

                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return deleteProductAccount(
                          context, product.name, product.id, widget.accountId);
                    }).then((value) {
                  setState(() {
                    accountTable = getAccount(widget.accountId);
                  });
                });
              },
              child: Icon(Icons.disabled_by_default_outlined),
            ),
          ),
        ],
      );
    }).toList();
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
    rows.add(
      DataRow(
        cells: [
          DataCell(Text('propina voluntaria')),
          DataCell(Text('%')),
          DataCell(TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            controller: percentController,
            onChanged: (value) {
              setState(() {
                percent = num.parse(value);
                propineController.text = (_total * (percent / 100)).toString();
                propine = _total * (percent / 100);
              });
            },
          )),
          DataCell(TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            controller: propineController,
            onChanged: (value) {
              setState(() {
                percentController.text =
                    ((num.parse(value) * 100) / (_total)).toString();
                // propine = num.parse(value);
                percent = ((num.parse(value) * 100) / (_total));
                propine = num.parse(value);
              });
            },
          )),
          // DataCell(Text((_total * (percent / 100)).toString())),
          DataCell(Text('')),
        ],
      ),
    );

    rows.add(
      DataRow(
        cells: [
          DataCell(Text('')),
          DataCell(Text('')),
          DataCell(Text('Total + propina:')),
          DataCell(Text((totalAddPropine).toString())),
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

// Future<String?> selectFolder() async {
//   String? folderPath = await FilePicker.platform.getDirectoryPath();
//   if (folderPath != null) {
//     return folderPath;
//   } else {
//     return null;
//   }
// }
