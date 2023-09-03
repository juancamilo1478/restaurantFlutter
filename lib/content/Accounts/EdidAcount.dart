import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditDialog extends StatefulWidget {
  final int initialQuantity;
  final String nameProduct;
  final int idAccount;
  final String idProduct;
  const EditDialog(
      {Key? key,
      required this.initialQuantity,
      required this.nameProduct,
      required this.idAccount,
      required this.idProduct})
      : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late int quantity;
  TextEditingController _quantityController = TextEditingController();
  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
    _quantityController = TextEditingController(text: quantity.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.nameProduct} cantidad'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            maxLength: 3,
            controller: _quantityController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
            ],
            onChanged: (value) {
              try {
                quantity = int.parse(value);
              } catch (e) {
                // Manejar el error de conversión si es necesario
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final url = Uri.http('localhost:3001', '/accounts/product');
                final response = await http.put(
                  url,
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'accountId': widget.idAccount,
                    'productId': widget.idProduct,
                    'quantity': quantity,
                    'oldQuantity': widget.initialQuantity
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
                  if (int.parse(productStore.inventory) > 5) {
                    Navigator.of(context).pop();
                  }
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
                                Navigator.of(context)
                                    .pop(); // Cerrar el AlertDialog
                                Navigator.of(context).pop();
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content:
                          Text("Se produjo un error al cargar los datos: $e"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Cerrar el AlertDialog
                            Navigator.of(context).pop();
                          },
                          child: Text("Aceptar"),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text('Guardar'),
          ),
        ],
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
}
