import 'package:flutter/material.dart';

class pay extends StatefulWidget {
  @override
  State<pay> createState() => _payState();
}

class _payState extends State<pay> {
  String? selection = "Efective";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 177, 27, 16),
          title: Row(
            children: [
              Icon(Icons.warning_rounded),
              Text("  Selecciona medio de pago")
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              DropdownButton(
                value: selection,
                items: [
                  DropdownMenuItem(
                    value: 'Efective',
                    child: Text('Efectivo'),
                  ),
                  DropdownMenuItem(
                    value: 'card',
                    child: Text('Tarjeta'),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    selection = value!;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (selection != "") {
                      Navigator.pop(context, selection);
                    }
                  },
                  child: Text("Seleccionar")),
            ],
          ),
        ));
  }
}
