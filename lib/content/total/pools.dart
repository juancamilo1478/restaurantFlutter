import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/ResponsesDatas.dart';

Widget getpool(List<pool> pooldatas) {
  num _total = 0;
  for (var data in pooldatas) {
    _total += data.price * data.quantity;
  }
  return Container(
    color: Color.fromARGB(255, 17, 17, 17),
    child: Column(
      children: [
        Center(
            child: Text("Piscinas",
                style: TextStyle(fontSize: 30, color: Colors.white))),
        DataTable(columns: [
          DataColumn(
              label: Text('Nombre', style: TextStyle(color: Colors.white))),
          DataColumn(
              label: Text('Precio', style: TextStyle(color: Colors.white))),
          DataColumn(
              label: Text('cantidad', style: TextStyle(color: Colors.white))),
          DataColumn(
              label: Text('total', style: TextStyle(color: Colors.white))),
        ], rows: _OnePool(pooldatas)),
        Row(
          children: [
            Text("Total", style: TextStyle(fontSize: 30, color: Colors.white)),
            SizedBox(
              width: 30,
            ),
            Text(_total.toString(),
                style: TextStyle(fontSize: 30, color: Colors.white))
          ],
        )
      ],
    ),
  );
}

List<DataRow> _OnePool(List<pool> pool) {
  final List<DataRow> rows = pool.map((polldata) {
    return DataRow(
      cells: [
        DataCell(Text(
          polldata.name,
          style: TextStyle(color: Colors.white),
        )),
        DataCell(Text(
          polldata.quantity.toString(),
          style: TextStyle(color: Colors.white),
        )),
        DataCell(Text(
          polldata.price.toString(),
          style: TextStyle(color: Colors.white),
        )),
        DataCell(Text(
          (polldata.price * polldata.quantity).toString(),
          style: TextStyle(color: Colors.white),
        )),
      ],
    );
  }).toList();
  return rows;
}
