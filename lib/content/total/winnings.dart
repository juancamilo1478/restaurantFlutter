import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/total.dart';
import 'package:http/http.dart' as http;

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

  void _myFunction(RestaurantModel data) {
    setState(() {
      listWidyed = [];
    });
    totalCard = 0;
    totalEfective = 0;
    List<Widget> data1;
    List<Widget> data2;
    List<Widget> data3;
    List<Widget> data4;
    data2 = categorieTable(data.restaurant, "Restaurante");
    data1 = categorieTable(data.iceCream, "Helados");
    data3 = categorieTable(data.sweet, "Dulces");
    data4 = categorieTable(data.other, "Otros");
    listWidyed.addAll(data1);
    listWidyed.addAll(data2);
    listWidyed.addAll(data3);
    listWidyed.addAll(data4);
    Widget finish = totalDate(totalEfective, totalCard);
    listWidyed.addAll([finish]);
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
                _getDatas(
                    '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}');
              },
              child: Text('Seleccionar fecha'),
            ),
            SizedBox(height: 16),
            Text(
              'Fecha : ${selectedDate != null ? selectedDate.toString() : "Sin seleccionar"}',
            ),
            if (listWidyed.isNotEmpty) ...listWidyed,
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
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        totalDatas = RestaurantModel.fromJson(jsonData);
        if (totalDatas == null) {
          listWidyed = [];
        } else {
          _myFunction(RestaurantModel.fromJson(jsonData));
        }
      });
    } else {
      setState(() {
        listWidyed = [];
      });
      throw Exception('Error al cargar los datos');
    }
  }

  List<Widget> categorieTable(MenuCategory data, String name) {
    List<Widget> widgets = [];

    // Aquí puedes construir y retornar el widget que desees.
    widgets.add(Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 140, 197,
            243), // Puedes establecer el color de fondo del container
        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0), // Color del borde
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
              Text(name),
              SizedBox(
                width: 20,
                height: 50,
              ),
              Text('Efectivo')
            ],
          ),
          DataTable(
            columns: [
              DataColumn(label: Text('Producto')),
              DataColumn(label: Text('Cantidad')),
              DataColumn(label: Text('Valor')),
              DataColumn(label: Text('Total')),
            ],
            rows: _products(data.effective, "efective"),
          ),
        ],
      ),
    ));
    widgets.add(Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 140, 197,
            243), // Puedes establecer el color de fondo del container
        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0), // Color del borde
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
              Text(name),
              SizedBox(
                width: 20,
                height: 50,
              ),
              Text('Tarjeta')
            ],
          ),
          DataTable(
            columns: [
              DataColumn(label: Text('Producto')),
              DataColumn(label: Text('Cantidad')),
              DataColumn(label: Text('Valor')),
              DataColumn(label: Text('Total')),
            ],
            rows: _products(data.card, "card"),
          ),
        ],
      ),
    ));

    return widgets;
  }

  List<DataRow> _products(List<MenuItem> products, String categorie) {
    num _total = 0;
    for (var data in products) {
      _total = (data.price * data.quantity) + _total;
    }
    if (categorie == "card") {
      totalCard = totalCard + _total;
    }
    if (categorie == "efective") {
      totalEfective = totalEfective + _total;
    }
    final List<DataRow> rows = products.map((product) {
      return DataRow(
        cells: [
          DataCell(Text(product.name)),
          DataCell(Text(product.quantity.toString())),
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
          DataCell(Text(_total.toString())),
        ],
      ),
    );

    return rows;
  }

  Widget totalDate(num totalEfective, num totalCard) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Efectivo total')),
        DataColumn(label: Text('Tarjetas total')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text(totalEfective.toString())),
          DataCell(Text(totalCard.toString())),
        ]),
      ],
    );
  }
}
