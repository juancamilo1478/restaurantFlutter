import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/Account.dart';

class kitchen extends StatefulWidget {
  final List<ProductAccount> data;

  const kitchen({required this.data});

  @override
  _kitchenState createState() => _kitchenState();
}

class _kitchenState extends State<kitchen> {
  List<ProductAccount> productsfinal = [];
  List<DataRow> _printTable(List<ProductAccount> products) {
    final List<DataRow> rows = products.map((product) {
      return DataRow(
        cells: [
          DataCell(Text(product.name)),
          DataCell(Text(product.quantity.toString())),
          DataCell(InkWell(
            onTap: () {
              setState(() {
                productsfinal =
                    products.where((p) => p.id != product.id).toList();
              });
              print(productsfinal);
            },
            child: Icon(Icons.delete),
          )),
        ],
      );
    }).toList();

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Seleccionar productos'),
          backgroundColor: Colors.black,
        ),
        body: Container(
          padding: EdgeInsets.all(40),
          color: const Color.fromARGB(255, 194, 193, 192),
          constraints: BoxConstraints.expand(),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsetsDirectional.all(10),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Cantidad')),
                    DataColumn(label: Text('Agregar')),
                  ],
                  rows: _SelectProduct(widget.data),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.all(10),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              productsfinal.length == 0
                  ? Text('Agrega Productos para imprimir')
                  : Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DataTable(columns: [
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Cantidad')),
                            DataColumn(label: Text('Borrar')),
                          ], rows: _printTable(productsfinal)),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, productsfinal);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.print_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('data')
                                ],
                              )),
                        ),
                      ],
                    )
            ],
          ),
        ));
  }

  List<DataRow> _SelectProduct(List<ProductAccount> products) {
    final List<DataRow> rows = products.map((product) {
      String cuantiti = product.quantity.toString();
      TextEditingController quantityController =
          TextEditingController(text: cuantiti);

      return DataRow(
        cells: [
          DataCell(Text(product.name)),
          DataCell(
            TextFormField(
              controller: quantityController, // Agrega esta línea
              maxLength: 2,
              onChanged: (value) {
                cuantiti = value;
              },
            ),
          ),
          DataCell(InkWell(
            onTap: () {
              int myInt = cuantiti!.isNotEmpty ? int.parse(cuantiti!) : 0;
              int index = productsfinal
                  .indexWhere((indexProduct) => product.id == indexProduct.id);
              {
                if (index != -1) {
                  setState(() {
                    productsfinal[index] = ProductAccount(
                        id: product.id,
                        type: product.type,
                        name: product.name,
                        price: product.price,
                        photo: product.photo,
                        store: product.store,
                        quantity: int.parse(cuantiti));
                  });
                } else {
                  print(cuantiti);
                  setState(() {
                    productsfinal.add(ProductAccount(
                      id: product.id,
                      type: product.type,
                      name: product.name,
                      price: product.price,
                      photo: product.photo,
                      store: product.store,
                      quantity: myInt,
                    ));
                  });
                }
              }
            },
            child: Icon(Icons.add_circle_outline),
          )),
        ],
      );
    }).toList();

    return rows;
  }
}
