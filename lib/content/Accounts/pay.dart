import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class pay extends StatefulWidget {
  final num total;
  pay({required this.total});
  @override
  State<pay> createState() => _payState();
}

class _payState extends State<pay> {
  int box = 0;
  int card = 0;

  TextEditingController _boxtext = TextEditingController();
  TextEditingController _cardtext = TextEditingController();

  @override
  void initState() {
    super.initState();
    _boxtext.text = box.toString();
    _cardtext.text = card.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 221, 182, 10),
        title: Row(
          children: [Icon(Icons.warning_rounded), Text("  Selecciona pago")],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: Text(
                "Total: ${widget.total}",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              width: 250.0,
              child: Row(
                children: [
                  Text(
                    "Efectivo:",
                    style: TextStyle(fontSize: 25),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _boxtext,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          box = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 250.0,
              child: Row(
                children: [
                  Text(
                    "Tarjeta:",
                    style: TextStyle(fontSize: 25),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _cardtext,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
                      ],
                      // decoration: InputDecoration(
                      //   labelText: 'Tarjeta',
                      // ),
                      onChanged: (value) {
                        setState(() {
                          card = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (widget.total == card + box)
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Acción que deseas realizar cuando se haga clic en el botón
                    Navigator.pop(context, {'box': box, 'card': card});
                  },
                  child: Text("Archivar"),
                ),
              )
          ],
        ),
      ),
    );
  }
}
