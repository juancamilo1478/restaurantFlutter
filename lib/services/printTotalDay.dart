import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/total.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

void printDay(
    BuildContext context, RestaurantModel data, String DateDay) async {
  final pdf = pw.Document();
  final image = await imageFromAssetBundle('assets/images/logo1.png');
  final fontSize = 20.0; // Tamaño de fuente predefinido
  final paddingHorizontal = 20.0;
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return buildPrintDay(image, data, DateDay);
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

pw.Widget buildPrintDay(
    pw.ImageProvider image, RestaurantModel datas, String DateDay) {
  num IceTotal = 0;
  num sweeTotal = 0;
  num restaurantTotal = 0;
  num otherTotal = 0;
  final fontSize = 6.0; // Tamaño de fuente predefinido
  final paddingHorizontal = 10.0;
  for (var data in datas.iceCream) {
    IceTotal += data.price * data.quantity;
  }
  for (var data in datas.sweet) {
    sweeTotal += data.price * data.quantity;
  }
  for (var data in datas.restaurant) {
    restaurantTotal += data.price * data.quantity;
  }
  for (var data in datas.other) {
    otherTotal += data.price * data.quantity;
  }
  // Aquí debes agregar el contenido que deseas mostrar en el PDF.
  // Puedes usar los widgets proporcionados por la biblioteca pdf (pw).

  return pw.Center(
      child: pw.Column(children: [
    pw.Container(
        constraints: pw.BoxConstraints(maxWidth: 160),
        child: pw.FittedBox(
          fit: pw.BoxFit.scaleDown,
          child: pw.Text(DateDay, style: pw.TextStyle(fontSize: fontSize * 3)),
        )),
    pw.Table(
        tableWidth: pw.TableWidth.max,
        columnWidths: {
          0: pw.FixedColumnWidth(75), // Ancho fijo para la primera columna
          1: pw.FixedColumnWidth(20),
          2: pw.FixedColumnWidth(75) // Ancho fijo para la segunda columna
        },
        border: pw.TableBorder.all(width: 1),
        children: [
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      'Helados',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      '',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
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
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
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
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      'total',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    )),
                  )),
            ),
          ]),
          for (var product in datas.iceCream)
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
                        (product.price * product.quantity).toString(),
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    )),
              ],
            ),
          // finish for
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 16,
                    child: pw.Center(
                        child: pw.Text(
                      'Total',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 16,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 16,
                    child: pw.Center(
                        child: pw.Text(
                      IceTotal.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.8,
                      ),
                    )),
                  )),
            ),
          ]),
          // table card iceCream
          /////////////////////////////////////////ice cream finish

          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      'Dulces',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      '',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
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
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
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
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      'total',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),
          for (var product in datas.sweet)
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
                        (product.price * product.quantity).toString(),
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    )),
              ],
            ),
          // finish for
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      'Total',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      sweeTotal.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),

          //////////////////////////init other
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      'Otros',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      '',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
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
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
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
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      'total',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    )),
                  )),
            ),
          ]),
          for (var product in datas.other)
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
                        (product.price * product.quantity).toString(),
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    )),
              ],
            ),
          // finish for
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      'Total',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      otherTotal.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),
          // cardfinish for card
//finish total card

          //finisth other init restaurant
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      'Restaurante',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      '',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
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
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
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
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      'total',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    )),
                  )),
            ),
          ]),
          for (var product in datas.restaurant)
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
                        (product.price * product.quantity).toString(),
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                    )),
              ],
            ),
          // finish for
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      'Total',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 12,
                    child: pw.Center(
                        child: pw.Text(
                      restaurantTotal.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),
          // car
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      'Recaudo dia:',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    )),
                  )),
            ),
          ]),
          //efectivo
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      'Efectivo:',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.2,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      datas.box.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.3,
                      ),
                    )),
                  )),
            ),
          ]),
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      'Helados',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      '-' + IceTotal.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.3,
                      ),
                    )),
                  )),
            ),
          ]),
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      'Dulces',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      '-' + sweeTotal.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.3,
                      ),
                    )),
                  )),
            ),
          ]),
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      'Otros',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      '-' + otherTotal.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.3,
                      ),
                    )),
                  )),
            ),
          ]),
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      'total Efectivo',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      (datas.box - (IceTotal + otherTotal + sweeTotal))
                          .toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.3,
                      ),
                    )),
                  )),
            ),
          ]),
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      'tarjetas:',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      // (Icecard + restaurantcard + otherCard + sweetCard)
                      datas.card.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.3,
                      ),
                    )),
                  )),
            ),
          ]),
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      'Recaudo:',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.2,
                      ),
                    )),
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      ((datas.box + datas.card) -
                              (IceTotal + otherTotal + sweeTotal))
                          .toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),
        ])
  ])); // Solo se está devolviendo un pw.Center como ejemplo, reemplaza esto con el contenido real.
}
