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
  num IceEfecti = 0;
  num Icecard = 0;
  num sweetEfecti = 0;
  num sweetCard = 0;
  num restaurantEfective = 0;
  num restaurantcard = 0;
  num otherEfective = 0;
  num otherCard = 0;
  final fontSize = 6.0; // Tamaño de fuente predefinido
  final paddingHorizontal = 10.0;
  for (var data in datas.iceCream.effective) {
    IceEfecti += data.price * data.quantity;
  }
  for (var data in datas.iceCream.card) {
    Icecard += data.price * data.quantity;
  }
  for (var data in datas.sweet.card) {
    sweetCard += data.price * data.quantity;
  }
  for (var data in datas.sweet.effective) {
    sweetEfecti += data.price * data.quantity;
  }
  for (var data in datas.other.card) {
    otherCard += data.price * data.quantity;
  }
  for (var data in datas.other.effective) {
    otherEfective += data.price * data.quantity;
  }
  for (var data in datas.restaurant.card) {
    restaurantcard += data.price * data.quantity;
  }
  for (var data in datas.restaurant.effective) {
    restaurantEfective += data.price * data.quantity;
  }
  //
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
                      'Efectivo',
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
          for (var product in datas.iceCream.effective)
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
                      IceEfecti.toString(),
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
                        fontSize: fontSize * 1.8,
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
                      'tarjetas',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.8,
                      ),
                    )),
                  )),
            ),
          ]), // for products card
          for (var product in datas.iceCream.card)
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
            ), //finish for card
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
                        fontSize: fontSize * 1.8,
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
                      Icecard.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.8,
                      ),
                    )),
                  )),
            ),
          ]), //finish total card
          ///total
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 40,
                    child: pw.Center(
                        child: pw.Text(
                      'Helados total:',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.4,
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
                    height: 40,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 40,
                    child: pw.Center(
                        child: pw.Text(
                      (Icecard + IceEfecti).toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.8,
                      ),
                    )),
                  )),
            ),
          ]),
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
                      'Efectivo',
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
          for (var product in datas.sweet.effective)
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
                      sweetEfecti.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),
          // table card sweet
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
                      'tarjetas',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]), // for products card
          for (var product in datas.sweet.card)
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
            ), //finish for card
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
                      sweetCard.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]), //finish total card
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      'Dulce Total:',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.3,
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
                    height: 20,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      (sweetCard + sweetEfecti).toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.6,
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
                      'Efectivo',
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
          for (var product in datas.other.effective)
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
                      otherEfective.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),
          // card
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
                      'tarjetas',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]), // for products card
          for (var product in datas.other.card)
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
            ), //finish for card
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
                      otherCard.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]), //finish total card
          ///total
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      'otros total:',
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
                    height: 20,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 20,
                    child: pw.Center(
                        child: pw.Text(
                      (otherCard + otherEfective).toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),
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
                      'Efectivo',
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
          for (var product in datas.restaurant.effective)
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
                      restaurantEfective.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]),
          // card
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
                      'tarjetas',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]), // for products card
          for (var product in datas.restaurant.card)
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
            ), //finish for card
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
                      restaurantcard.toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
                      ),
                    )),
                  )),
            ),
          ]), //finish total card
          ///total
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 40,
                    child: pw.Center(
                        child: pw.Text(
                      'Restaurante total:',
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
                    height: 40,
                  )),
            ),
            pw.Container(
              color: PdfColor.fromHex('#000000'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 40,
                    child: pw.Center(
                        child: pw.Text(
                      (restaurantcard + restaurantEfective).toString(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#ffffff'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.5,
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
                      (IceEfecti +
                              restaurantEfective +
                              otherEfective +
                              sweetEfecti)
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
                      (Icecard + restaurantcard + otherCard + sweetCard)
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
                      'Total:',
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
                      (Icecard +
                              IceEfecti +
                              otherCard +
                              otherEfective +
                              sweetCard +
                              sweetEfecti +
                              restaurantcard +
                              restaurantEfective)
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
          pw.TableRow(children: [
            pw.Container(
              color: PdfColor.fromHex('#ffffff'),
              alignment: pw.Alignment.center,
              child: pw.Padding(
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: pw.SizedBox(
                    height: 40,
                    child: pw.Center(
                        child: pw.Text(
                      'Total - otros -Restaurante tarjetas',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: fontSize * 1.1,
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
                      ((Icecard +
                                  IceEfecti +
                                  otherCard +
                                  otherEfective +
                                  sweetCard +
                                  sweetEfecti +
                                  restaurantcard +
                                  restaurantEfective) -
                              (Icecard +
                                  IceEfecti +
                                  otherCard +
                                  otherEfective +
                                  sweetCard +
                                  sweetEfecti +
                                  restaurantcard))
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
