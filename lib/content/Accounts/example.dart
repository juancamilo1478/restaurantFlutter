import 'package:flutter/material.dart';

class DataSelectionScreen extends StatelessWidget {
  final String dato;

  const DataSelectionScreen({required this.dato});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar dato'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dato recibido: $dato',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                // Devolver el dato seleccionado
                Navigator.pop(context, 'Dato seleccionado');
              },
              child: Text('Seleccionar'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Abrir la pantalla de selección de datos y esperar el resultado
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataSelectionScreen(dato: 'Hola'),
                  ),
                );

                // Mostrar el resultado en un diálogo
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Dato seleccionado'),
                    content: Text(result),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Seleccionar dato'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
