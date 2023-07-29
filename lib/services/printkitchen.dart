import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/Account.dart';
import 'package:flutter_restaurant/models/waiters.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

void printKitchen(BuildContext context, List<ProductAccount> data,
    String nameTable, String nameSector, WaiterModel waiter) async {
  final pdf = pw.Document();

  final image = await imageFromAssetBundle('assets/images/logo1.png');
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return buildprintkitchen(
            image, data, nameTable, nameSector, waiter.name);
      },
      pageFormat: PdfPageFormat(130.0, double.infinity),
    ),
  );

  final pdfBytes = await pdf.save();

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Container(
        width: 600,
        height: 600,
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
            final PdfPageFormat pageFormat =
                PdfPageFormat(58.0, double.infinity);

            await Printing.layoutPdf(
              format: pageFormat,
              onLayout: (PdfPageFormat format) async {
                return pdfBytes;
              },
              usePrinterSettings: true,
            );
          },
          child: Text('Imprimir'),
        ),
      ],
    ),
  );
}

pw.Widget buildprintkitchen(image, List<ProductAccount> datas, String nametable,
    String Sector, String nameWaiter) {
  final fontSize = 12.0; // Tamaño de fuente predefinido
  final paddingHorizontal = 20.0;
  DateTime now = DateTime.now();
  String time = '${now.hour}:${now.minute}';
  return pw.Center(
    child: pw.Column(
      children: [
        pw.Column(children: [
          pw.Container(
              constraints: pw.BoxConstraints(maxWidth: 160),
              child: pw.FittedBox(
                fit: pw.BoxFit.scaleDown,
                child: pw.Text('$Sector Mesa #$nametable',
                    style: pw.TextStyle(fontSize: fontSize * 0.8)),
              )),
          pw.Container(
              constraints: pw.BoxConstraints(maxWidth: 160),
              child: pw.FittedBox(
                fit: pw.BoxFit.scaleDown,
                child: pw.Text('Hora impreso $time',
                    style: pw.TextStyle(fontSize: fontSize * 0.8)),
              )),
          pw.Container(
              constraints: pw.BoxConstraints(maxWidth: 160),
              child: pw.FittedBox(
                fit: pw.BoxFit.scaleDown,
                child: pw.Text('$nameWaiter',
                    style: pw.TextStyle(fontSize: fontSize * 0.8)),
              )),
        ]),
        pw.SizedBox(height: 9.0),
        pw.Divider(),
        pw.Align(
          alignment: pw.Alignment.topCenter,
          child: pw.Image(image, width: 130, height: 150),
        ),
        pw.Table(
          tableWidth: pw.TableWidth.max,
          columnWidths: {
            0: pw.FixedColumnWidth(80), // Ancho fijo para la primera columna
            1: pw.FixedColumnWidth(80), // Ancho fijo para la segunda columna
          },
          border: pw.TableBorder.all(width: 1),
          children: [
            pw.TableRow(
              children: [
                pw.Container(
                  color: PdfColor.fromHex('#000000'),
                  alignment: pw.Alignment.center,
                  child: pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                          horizontal: paddingHorizontal),
                      child: pw.SizedBox(
                        height: 12,
                        child: pw.Center(
                            child: pw.Text(
                          'Nombre',
                          style: pw.TextStyle(
                            color: PdfColor.fromHex('#ffffff'),
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 6,
                          ),
                        )),
                      )),
                ),
                pw.Container(
                  color: PdfColor.fromHex('#000000'),
                  alignment: pw.Alignment.center,
                  child: pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                          horizontal: paddingHorizontal),
                      child: pw.SizedBox(
                        height: 12,
                        child: pw.Center(
                            child: pw.Text(
                          '#',
                          style: pw.TextStyle(
                            color: PdfColor.fromHex('#ffffff'),
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        )),
                      )),
                ),
              ],
            ),
            for (var product in datas)
              pw.TableRow(
                children: [
                  pw.Container(
                    padding: pw.EdgeInsets.only(bottom: 8, top: 8),
                    alignment: pw.Alignment.center,
                    child: pw.Center(
                        child: pw.Text(
                      product.name,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 0.8,
                      ),
                    )),
                  ),
                  pw.Container(
                      padding: pw.EdgeInsets.only(bottom: 8, top: 8),
                      alignment: pw.Alignment.center,
                      child: pw.Center(
                        child: pw.Text(
                          product.quantity.toString(),
                          style: pw.TextStyle(fontSize: fontSize),
                        ),
                      )),
                ],
              ),
          ],
        ),
      ],
    ),
  );
}
