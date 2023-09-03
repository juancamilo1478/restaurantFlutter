import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class addProductAccount extends StatefulWidget {
  final int idAccount;

  const addProductAccount({
    Key? key,
    required this.idAccount,
  }) : super(key: key);

  @override
  _addProductAccountstate createState() => _addProductAccountstate();
}

class _addProductAccountstate extends State<addProductAccount> {
  TextEditingController _controllersearch = TextEditingController();
  late String quantity = '';
  late Future<List<Product>> _listProducts;
  late String search = '';
  TextEditingController _quantityController = TextEditingController();

  Future<List<Product>> _getProducts(String searchTerm) async {
    final Uri url =
        Uri.parse('http://localhost:3001/products?name=$searchTerm');
    final response = await http.get(
      url,
    );
    final List<Product> productos = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var item in jsonData) {
        productos.add(Product(
          item['id'].toString(),
          item['type'],
          item['name'],
          item['price'].toString(),
          item['store'].toString(),
        ));
      }
      return productos;
    } else {
      throw Exception("Fallo la petición");
    }
  }

  _addProduct(String idProduct) async {
    try {
      final Uri url = Uri.parse('http://localhost:3001/accounts/product');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "accountId": widget.idAccount,
          "productId": idProduct,
          "quantity": quantity == '' ? 1 : quantity
        }),
      );
      if (response.statusCode == 201) {
        String body = utf8.decode(response.bodyBytes);
        Product? productStore;
        final jsonData = jsonDecode(body);
        productStore = Product(
          jsonData['id'].toString(),
          jsonData['type'],
          jsonData['name'],
          jsonData['price'].toString(),
          jsonData['store'].toString(),
        );
        if (int.parse(productStore.inventory) <= 5) {
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
                    "Quedan pocas unidades de ${productStore!.name} # de unidades: ${productStore.inventory}"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cerrar el AlertDialog
                    },
                    child: Text("Aceptar"),
                  ),
                ],
              );
            },
          );
          // Espera hasta que el usuario cierre el diálogo antes de continuar
        }
      } else {
        throw Exception(
            "Fallo la petición: ${jsonDecode(response.body)['error']}");
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("${e}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el AlertDialog
                },
                child: Text("Aceptar"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _listProducts = _getProducts(search);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar producto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              child: TextField(
                decoration: InputDecoration(hintText: 'Cantidad'),
                maxLength: 3,
                controller: _quantityController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
                ],
                onChanged: (value) {
                  try {
                    quantity = value;
                  } catch (e) {
                    // Manejar el error de conversión si es necesario
                  }
                },
              ),
            ),

            TextField(
              decoration: InputDecoration(hintText: 'buscar'),
              maxLength: 20,
              controller: _controllersearch,
              onChanged: (value) {
                setState(() {
                  search = value;
                  _listProducts = _getProducts(search);
                });
              },
            ),

            SizedBox(
                height:
                    10), // Agrega un espacio entre los TextField y el DataTable
            FutureBuilder(
              future: _listProducts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DataTable(
                    columns: [
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Inventario')),
                      DataColumn(label: Text('Precio')),
                      DataColumn(label: Text('Categoria')),
                      DataColumn(label: Text('Agregar')),
                    ],
                    rows: _products(snapshot.data ?? []),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text(
                      "Error al obtener los datos"); // Agrega el widget de error aquí
                } else {
                  return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
      ],
    );
  }

  List<DataRow> _products(List<Product> products) {
    return products.map((product) {
      return DataRow(cells: [
        DataCell(Text(product.name)),
        DataCell(Text(product.inventory.toString())),
        DataCell(Text(product.price.toString())),
        DataCell(Text(product.type)),
        DataCell(InkWell(
            onTap: () async {
              await _addProduct(product.id);
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.add_circle_outline_sharp,
              size: 25,
              color: Colors.green,
            ))),
      ]);
    }).toList();
  }
}
