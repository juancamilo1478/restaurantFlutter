import 'package:flutter/material.dart';
import 'package:flutter_restaurant/content/inventory/addNewProduct.dart';

class addInventory extends StatefulWidget {
  final Function? Refresh;
  final Function? SearchName;
  addInventory({this.Refresh, this.SearchName});

  @override
  State<addInventory> createState() => _addInventoryState();
}

class _addInventoryState extends State<addInventory> {
  TextEditingController _controller = TextEditingController();
  String? _inputValue;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 52, 53, 53),
              border: Border.all(
                color: Colors
                    .transparent, // Establecer el color del borde en transparente
              ),
            ),
            child: Center(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(64, 129, 128, 128),
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.white),
                          controller: _controller,
                          onChanged: (value) async {
                            setState(() {
                              _inputValue = value;
                            });
                            await widget.SearchName?.call(value);
                            widget.Refresh?.call();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 52, 53, 53),
              border: Border.all(
                color: Colors
                    .transparent, // Establecer el color del borde en transparente
              ),
            ),
            child: Center(),
          ),
        ),
        Expanded(
          child: Container(
            height: 50,
            color: const Color.fromARGB(255, 52, 53, 53),
            child: Center(
              child: Row(
                children: [
                  Text(
                    'Agregar',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddNewProduct(); // Mostrar el diálogo AddNewProduct
                        },
                      ).then((value) {
                        widget.Refresh?.call();
                      });
                    },
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
