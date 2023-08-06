import 'package:flutter/material.dart';

class ALertMensaje extends StatefulWidget {
  final String initialValue; // Nuevo parámetro para recibir el valor inicial

  ALertMensaje({required this.initialValue});

  State<ALertMensaje> createState() => _ALertMensajeState();
}

class _ALertMensajeState extends State<ALertMensaje> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 177, 27, 16),
          title: Row(
            children: [Icon(Icons.warning_rounded), Text(widget.initialValue)],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text("si")),
                  SizedBox(
                    width: 50.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text("No")),
                ],
              ),
            ],
          ),
        ));
  }
}
