import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/Account.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

void printAccount(BuildContext context, AccountModel data) async {
  final pdf = pw.Document();

  final image = await imageFromAssetBundle('assets/images/logo1.png');
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return buildprintData(image, data.products);
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

pw.Widget buildprintData(image, List<ProductAccount> datas) {
  int total = 0;

  for (var product in datas) {
    total += (product.price * product.quantity);
  }

  final fontSize = 6.0; // Tamaño de fuente predefinido
  final paddingHorizontal = 10.0;
  return pw.Center(
    child: pw.Column(
      children: [
        pw.Text('cuenta numero x', style: pw.TextStyle(fontSize: fontSize)),
        pw.SizedBox(height: 10.0),
        pw.Divider(),
        pw.Align(
          alignment: pw.Alignment.topCenter,
          child: pw.Image(image, width: 130, height: 200),
        ),
        pw.Table(
          tableWidth: pw.TableWidth.max,
          columnWidths: {
            0: pw.FixedColumnWidth(50), // Ancho fijo para la primera columna
            1: pw.FixedColumnWidth(20), // Ancho fijo para la segunda columna
            2: pw.FixedColumnWidth(30), // Ancho fijo para la tercera columna
            3: pw.FlexColumnWidth(60), // Ancho flexible para la última columna
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
                            fontSize: fontSize,
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
                            fontSize: fontSize,
                          ),
                        )),
                      )),
                ),
                pw.Container(
                  height: 12,
                  color: PdfColor.fromHex('#000000'),
                  alignment: pw.Alignment.center,
                  child: pw.Center(
                      child: pw.Text(
                    'Precio',
                    style: pw.TextStyle(
                      color: PdfColor.fromHex('#ffffff'),
                      fontWeight: pw.FontWeight.bold,
                      fontSize: fontSize * 0.8,
                    ),
                  )),
                ),
                pw.Container(
                  height: 12,
                  color: PdfColor.fromHex('#000000'),
                  alignment: pw.Alignment.center,
                  child: pw.Center(
                      child: pw.Text(
                    'Total',
                    style: pw.TextStyle(
                      color: PdfColor.fromHex('#ffffff'),
                      fontWeight: pw.FontWeight.bold,
                      fontSize: fontSize * 0.8,
                    ),
                  )),
                ),
              ],
            ),
            for (var product in datas)
              pw.TableRow(
                children: [
                  pw.Container(
                    height: 12,
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
                      height: 12,
                      alignment: pw.Alignment.center,
                      child: pw.Center(
                        child: pw.Text(
                          product.quantity.toString(),
                          style: pw.TextStyle(fontSize: fontSize),
                        ),
                      )),
                  pw.Container(
                      height: 12,
                      alignment: pw.Alignment.center,
                      child: pw.Center(
                        child: pw.Text(
                          product.price.toString(),
                          style: pw.TextStyle(fontSize: fontSize),
                        ),
                      )),
                  pw.Container(
                      height: 12,
                      alignment: pw.Alignment.center,
                      child: pw.Center(
                        child: pw.Text(
                          (product.price * product.quantity).toString(),
                          style: pw.TextStyle(fontSize: fontSize),
                        ),
                      )),
                ],
              ),
          ],
        ),
        pw.Table(tableWidth: pw.TableWidth.max, children: [
          pw.TableRow(
            children: [
              pw.Center(
                child: pw.Text(
                  'Total:',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize * 2,
                  ),
                ),
              ),
              pw.Container(
                alignment: pw.Alignment.topRight,
                child: pw.Text(
                  total.toString(),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize * 2,
                  ),
                ),
              ),
            ],
          ),
        ])
      ],
    ),
  );
}
