import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/content/Accounts/pay.dart';
import 'package:flutter_restaurant/models/Account.dart';
import 'package:flutter_restaurant/models/waiters.dart';
import 'package:flutter_restaurant/services/FinishAccount.dart';
import 'package:flutter_restaurant/services/printAccount.dart';
import 'package:http/http.dart' as http;

class editAccountHistory extends StatefulWidget {
  final int idAccount;
  final String date;
  final String state;
  const editAccountHistory(
      {required this.idAccount, required this.date, required this.state});

  @override
  State<editAccountHistory> createState() => _editAccountHistoryState();
}

class _editAccountHistoryState extends State<editAccountHistory> {
  late Future<AccountModel> accountTable;
  late Future<WaiterModel> _Waiter;
  int box = 0;
  int card = 0;
  int propine = 0;
  int? tableId = null;
  String state = '';
  String date = '';

  Future<AccountModel> getAccount(int idAccount) async {
    final Uri url =
        Uri.parse('http://localhost:3001/accounts/product/$idAccount');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final List<ProductAccount> products = [];

      for (var productData in jsonData['Products']) {
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
        date: jsonData['date'].toString(),
        state: jsonData['state'].toString(),
        propine: jsonData['propine'].toString(),
        waitersId: jsonData['WaitersId'],
        tableId: jsonData['TableId'],
        products: products,
      );
      setState(() {
        box = jsonData['box'];
        card = jsonData['card'];
        propine = jsonData['propine'];
        date = jsonData['date'];
        state = jsonData['state'];
      });
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
    accountTable = getAccount(widget.idAccount);
  }

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
                        '#' + widget.idAccount.toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                      Text('Fecha:  ${widget.date.toString()}  ',
                          style: TextStyle(fontSize: 15)),
                    ],
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
                ],
                rows: _products(account!.products, box + card, propine),
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
                    printAccount(
                        context,
                        account,
                        ((propine * 100) / (box + card - propine)),
                        "sector x",
                        widget.idAccount,
                        tableId.toString());
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
                      Text('Edtitar'),
                    ],
                  ),
                  onPressed: () async {
                    if (widget.state != "Active") {
                      final Result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => pay(
                                total: box + card - propine,
                                propine: propine.toInt()),
                          ));
                      final stateFinish = await finishAccount(
                        widget.idAccount,
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
                    } else {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.yellow,
                                ),
                                Text("Alerta"),
                              ],
                            ),
                            content: Text(
                                "No puedes Editar el pago en una cuenta activa"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Cerrar el AlertDialog
                                },
                                child: Text("Aceptar"),
                              ),
                            ],
                          );
                        },
                      );
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

  List<DataRow> _products(
      List<ProductAccount> products, int total, int propine) {
    final List<DataRow> rows = products.map((product) {
      return DataRow(
        cells: [
          DataCell(Text(product.name)),
          DataCell(
            Row(
              children: [
                Text(product.quantity.toString()),
                SizedBox(width: 5),
              ],
            ),
          ),
          DataCell(Text(product.price.toString())),
          DataCell(Text((product.price * product.quantity).toString())),
        ],
      );
    }).toList();
    rows.add(
      DataRow(
        cells: [
          DataCell(Text('')),
          DataCell(Text('')),
          DataCell(Text('Total:')),
          DataCell(Text((total - propine).toString())),
        ],
      ),
    );
    rows.add(DataRow(
      cells: [
        DataCell(Text('Propina')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text(
            propine.toString())), // Corrección: agregar paréntesis de cierre
        // Añadí una coma al final de esta línea para separarla correctamente
      ],
    ));
    rows.add(
      DataRow(
        cells: [
          DataCell(Text('')),
          DataCell(Text('')),
          DataCell(Text('Pago tarjeta:')),
          DataCell(Text((card).toString())),
        ],
      ),
    );
    rows.add(
      DataRow(
        cells: [
          DataCell(Text('')),
          DataCell(Text('')),
          DataCell(Text('Pago Efectivo:')),
          DataCell(Text((box).toString())),
        ],
      ),
    );
    rows.add(
      DataRow(
        cells: [
          DataCell(Text('')),
          DataCell(Text('')),
          DataCell(Text('Total + propina:')),
          DataCell(Text((box + card).toString())),
        ],
      ),
    );

    return rows;
  }
}

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
