import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/ResponsesDatas.dart';
import 'package:flutter_restaurant/models/total.dart';
import 'package:flutter_restaurant/services/printTotalDay.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_restaurant/content/total/pools.dart';

class winnings extends StatefulWidget {
  @override
  _winningsState createState() => _winningsState();
}

class _winningsState extends State<winnings> {
  List<Widget> listWidyed = [];
  DateTime? selectedDate;
  RestaurantModel? totalDatas;
  num totalEfective = 0;
  num totalCard = 0;
  void _addPool(List<pool> datapool) {
    Widget poolData = getpool(datapool);

    setState(() {
      listWidyed.addAll([poolData]);
    });
  }

  void _myFunction(RestaurantModel data, List<Propines> propinesList) {
    setState(() {
      listWidyed = [];
    });
    num _totalRestaurant = 0;
    num _totalIceCream = 0;
    num _totalSweet = 0;
    num _totalOther = 0;
    for (var item in data.restaurant) {
      _totalRestaurant += item.price * item.quantity;
    }
    for (var item in data.iceCream) {
      _totalIceCream += item.price * item.quantity;
    }
    for (var item in data.sweet) {
      _totalSweet += item.price * item.quantity;
    }
    for (var item in data.other) {
      _totalOther += item.price * item.quantity;
    }

    List<Widget> data1;
    List<Widget> data2;
    List<Widget> data3;
    List<Widget> data4;

    data2 = categorieTable(data.restaurant, "Restaurante", _totalRestaurant);
    data1 = categorieTable(data.iceCream, "Helados", _totalIceCream);
    data3 = categorieTable(data.sweet, "Dulces", _totalSweet);
    data4 = categorieTable(data.other, "Otros", _totalOther);
    Widget propine = getPropines(propinesList);
    listWidyed.addAll(data1);
    listWidyed.addAll(data2);
    listWidyed.addAll(data3);
    listWidyed.addAll(data4);
    Widget finish = totalDate(
        data.box, data.card, _totalIceCream, _totalSweet, _totalOther);
    listWidyed.addAll([finish]);
    listWidyed.addAll([propine]);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _selectDate(context);
                await _getDatas(
                    '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}');
                _getPoolWidyed(
                    '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}');
              },
              child: Text('Seleccionar fecha'),
            ),
            SizedBox(height: 16),
            Text(
              'Fecha : ${selectedDate != null ? selectedDate.toString() : "Sin seleccionar"}',
            ),
            if (listWidyed.isNotEmpty) ...listWidyed,
            if (listWidyed.isNotEmpty)
              SizedBox(
                height: 200.0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (listWidyed.isNotEmpty && totalDatas != null) {
                        printDay(context, totalDatas!,
                            '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}');
                      } else {
                        // Mostrar un mensaje o realizar alguna otra acción si no se cumplen las condiciones.
                      }
                    },
                    child: Text('Imprimir'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Función para mostrar el cuadro de diálogo de selección de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now(), // Fecha inicial al abrir el cuadro de diálogo
      firstDate: DateTime(2021), // Fecha mínima seleccionable
      lastDate: DateTime(2040), // Fecha máxima seleccionable
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _getPoolWidyed(String date) async {
    final urlpools = Uri.parse('http://localhost:3001/products/polday');
    final requestData = {
      'date': date,
    };
    final responsepool = await http.post(
      urlpools,
      body: jsonEncode(requestData),
      headers: {'Content-Type': 'application/json'},
    );
    if (responsepool.statusCode == 200) {
      final jsonDataPool = jsonDecode(responsepool.body);
      List<pool> poolList = jsonDataPool
          .map<pool>((item) =>
              pool(item['id'], item['name'], item['quantity'], item['price']))
          .toList();
      _addPool(poolList);
    } else {
      print("error care");
    }
  }

  Future<void> _getDatas(String date) async {
    final url = Uri.parse('http://localhost:3001/accounts/total/date');
    final requestData = {
      'date': date,
    };
    final response = await http.post(
      url,
      body: jsonEncode(requestData),
      headers: {'Content-Type': 'application/json'},
    );
    final urlWaiters = Uri.parse('http://localhost:3001/waiter/day');
    final responsewaiter = await http.put(
      urlWaiters,
      body: jsonEncode(requestData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 && responsewaiter.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final jsonDataWaiter = jsonDecode(responsewaiter.body);
      setState(() {
        totalDatas = RestaurantModel.fromJson(jsonData);
        if (totalDatas == null) {
          listWidyed = [];
        } else {
          List<Propines> propinesList = jsonDataWaiter
              .map<Propines>((item) => Propines(item['name'], item['propine']))
              .toList();
          _myFunction(RestaurantModel.fromJson(jsonData), propinesList);
        }
      });
    } else {
      setState(() {
        listWidyed = [];
      });
      throw Exception('Error al cargar los datos');
    }
  }

  List<Widget> categorieTable(List<MenuItem> data, String name, num total) {
    List<Widget> widgets = [];

    // Aquí puedes construir y retornar el widget que desees.
    widgets.add(Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 53, 53,
            53), // Puedes establecer el color de fondo del container
        border: Border.all(
          color: Color.fromARGB(179, 12, 204, 238), // Color del borde
          width: 2.0, // Ancho del borde
        ),
        borderRadius:
            BorderRadius.circular(10.0), // Radio de esquinas del container
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
              SizedBox(
                width: 20,
                height: 50,
              ),
            ],
          ),
          DataTable(
            columns: [
              DataColumn(
                  label: Text(
                'Producto',
                style: TextStyle(color: Colors.white),
              )),
              DataColumn(
                  label: Text(
                'Cantidad',
                style: TextStyle(color: Colors.white),
              )),
              DataColumn(
                  label: Text(
                'Valor',
                style: TextStyle(color: Colors.white),
              )),
              DataColumn(
                  label: Text(
                'Total',
                style: TextStyle(color: Colors.white),
              )),
            ],
            rows: _products(data, "efective", total),
          ),
        ],
      ),
    ));
    return widgets;
  }

  List<DataRow> _products(
      List<MenuItem> products, String categorie, num total) {
    final List<DataRow> rows = products.map((product) {
      return DataRow(
        cells: [
          DataCell(Text(
            product.name,
            style: TextStyle(color: Colors.white),
          )),
          DataCell(Text(
            product.quantity.toString(),
            style: TextStyle(color: Colors.white),
          )),
          DataCell(Text(
            product.price.toString(),
            style: TextStyle(color: Colors.white),
          )),
          DataCell(Text(
            (product.price * product.quantity).toString(),
            style: TextStyle(color: Colors.white),
          )),
        ],
      );
    }).toList();

    rows.add(
      DataRow(
        cells: [
          DataCell(Text('')),
          DataCell(Text('')),
          DataCell(Text(
            'Total:',
            style: TextStyle(fontSize: 30.0, color: Colors.white),
          )),
          DataCell(Text(
            total.toString(),
            style: TextStyle(fontSize: 30.0, color: Colors.white),
          )),
        ],
      ),
    );

    return rows;
  }

  Widget totalDate(num totalEfective, num totalCard, num totalIceCream,
      num totalSweet, num totalOther) {
    return DataTable(
      columns: [
        DataColumn(label: Text(' ')),
        DataColumn(label: Text('Tarjetas total')),
        DataColumn(label: Text('Efectivo total')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text("")),
          DataCell(Text(totalCard.toString())),
          DataCell(Text(totalEfective.toString())),
        ]),
        DataRow(cells: [
          DataCell(Text("Helados")),
          DataCell(Text("...")),
          DataCell(Text("-" + totalIceCream.toString())),
        ]),
        DataRow(cells: [
          DataCell(Text("Dulces")),
          DataCell(Text("...")),
          DataCell(Text("-" + totalSweet.toString())),
        ]),
        DataRow(cells: [
          DataCell(Text("Otros")),
          DataCell(Text("...")),
          DataCell(Text("-" + totalOther.toString())),
        ]),
        DataRow(cells: [
          DataCell(Text("Total")),
          DataCell(Text(totalCard.toString())),
          DataCell(Text(
              (totalEfective - (totalIceCream + totalOther + totalSweet))
                  .toString())),
        ]),
        DataRow(cells: [
          DataCell(Text("Recaudo")),
          DataCell(Text("...")),
          DataCell(Text(((totalEfective + totalCard) -
                  (totalIceCream + totalOther + totalSweet))
              .toString())),
        ])
      ],
    );
  }
}

Widget getPropines(List<Propines> propinesList) {
  return Container(
    color: Color.fromARGB(255, 23, 37, 39),
    child: DataTable(columns: [
      DataColumn(label: Text('Nombre', style: TextStyle(color: Colors.white))),
      DataColumn(label: Text('Propina', style: TextStyle(color: Colors.white))),
    ], rows: _Onewaiter(propinesList)),
  );
}

List<DataRow> _Onewaiter(List<Propines> propines) {
  final List<DataRow> rows = propines.map((waiter) {
    return DataRow(
      cells: [
        DataCell(Text(
          waiter.name,
          style: TextStyle(color: Colors.white),
        )),
        DataCell(Text(
          waiter.propine.toString(),
          style: TextStyle(color: Colors.white),
        )),
      ],
    );
  }).toList();
  return rows;
}
