import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/content/inventory/addInventory.dart';
import 'package:flutter_restaurant/content/inventory/deleteProduct.dart';
import 'package:flutter_restaurant/content/inventory/editInventory.dart';
import 'package:flutter_restaurant/models/product.dart';
import 'package:http/http.dart' as http;

class inventory extends StatefulWidget {
  @override
  State<inventory> createState() => _inventoryState();
}

class _inventoryState extends State<inventory> {
  late Future<List<Product>> listProducts;
  Future<List<Product>> _getProducts() async {
    final Uri url = Uri.parse('http://localhost:3001/products');
    final response = await http.get(url);
    final List<Product> productos = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var item in jsonData) {
        productos.add(Product(item['id'], item['type'], item['name'],
            item['price'].toString(), item['store'].toString()));
      }
      return productos;
    } else {
      throw Exception("Fallo la petición");
    }
  }

  //put product
  Future<List<Product>> putProduct(BuildContext context, int productId,
      int productStore, int productPrice, String productCategorie) async {
    final Uri url = Uri.parse('http://localhost:3001/products');
    final response = await http.get(url);
    final List<Product> productos = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var item in jsonData) {
        productos.add(Product(item['id'], item['type'], item['name'],
            item['price'], item['store']));
      }
      return productos;
    } else {
      throw Exception("Fallo la petición");
    }
  }

// initial state loading all products
  @override
  void initState() {
    listProducts = _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          addInventory(),
          Container(
            height: 500,
            child: FutureBuilder(
              future: listProducts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DataTable(
                    columns: [
                      DataColumn(label: Text('id')),
                      DataColumn(label: Text('nombre')),
                      DataColumn(label: Text('inventario')),
                      DataColumn(label: Text('precio')),
                      DataColumn(label: Text('Categoria')),
                      DataColumn(label: Text('editar')),
                      DataColumn(
                          label: Row(
                        children: [Icon(Icons.delete_forever), Text('Borrar')],
                      )),
                    ],
                    rows: _products(snapshot.data ?? []),
                  );
                  // Agrega el widget que deseas mostrar aquí
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text(
                      "Error al obtener los datos"); // Agrega el widget de error aquí
                } else {
                  return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
                }
              },
            ),
          )
        ],
      ),
    );
  }

  List<DataRow> _products(List<Product> products) {
    return products.map((product) {
      return DataRow(cells: [
        DataCell(Text(product.id.toString())),
        DataCell(Text(product.name)),
        DataCell(Text(product.inventory.toString())),
        DataCell(Text(product.price.toString())),
        DataCell(Text(product.type)),
        DataCell(InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) => EditInventoryDialog(
                  productId: product.id, // Replace with the actual product ID
                  productName: product.name,
                  productType: product.type,
                  productPrice: product.price,
                  productStore: product.inventory,
                ),
              );
              setState(() {
                listProducts = _getProducts();
              });
            },
            child: Icon(Icons.edit_rounded))),
        DataCell(InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    showDeleteProductDialog(context, product.id, product.name),
              );
              setState(() {
                listProducts = _getProducts();
              });
            },
            child: Icon(Icons.disabled_by_default_outlined)))
      ]);
    }).toList();
  }
}
