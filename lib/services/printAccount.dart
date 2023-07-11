import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/Account.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

void printAccount(BuildContext context) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text('Hola Mundo', style: pw.TextStyle(fontSize: 24)),
        );
      },
    ),
  );

  final pdfBytes = await pdf.save();

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Container(
        width: 300,
        height: 400,
        child: PdfPreview(
          build: (_) => pdfBytes,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cerrar'),
        ),
        ElevatedButton(
          onPressed: () async {
            await Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async => pdfBytes,
            );
          },
          child: Text('Imprimir'),
        ),
      ],
    ),
  );
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              printAccount(context);
            },
            child: Text('Generar y previsualizar PDF'),
          ),
        ),
      ),
    );
  }
}

buildprintData(image, List<ProductAccount> datas) => pw.Padding(
    padding: const pw.EdgeInsets.all(25),
    child: pw.Column(children: [
      pw.Text('cuenta'),
      pw.SizedBox(height: 10.0),
      pw.Divider(),
      pw.Align(
          alignment: pw.Alignment.topRight,
          child: pw.Image(image, width: 250, height: 250)),
      pw.Table(
        border: pw.TableBorder.all(width: 1),
        children: [
          pw.TableRow(children: [
            pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text('Nombre',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text('cantidad',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text('Precio',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text('Total',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))
          ]),
          for (var product in datas)
            pw.TableRow(children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(product.name),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(product.quantity.toString()),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(product.price.toString()),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text((product.price * product.quantity).toString()),
              )
            ])
        ],
      ),
    ]));
