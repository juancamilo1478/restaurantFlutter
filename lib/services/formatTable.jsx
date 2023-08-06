import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/total.dart';
 
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
void nombreDeLaFuncion(RestaurantModel, String ,nameData, num efective, int target) {
    



  }
  
    return  pw.TableRow(children: [
        pw.Container(
          color: PdfColor.fromHex('#9B9B9B'),
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
                    color: PdfColor.fromHex('#ffffff'),
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                )),
              )),
        ),
        pw.Container(
          color: PdfColor.fromHex('#9B9B9B'),
          alignment: pw.Alignment.center,
          child: pw.Padding(
              padding:
                  pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: pw.SizedBox(
                height: 12,
              )),
        ),
        pw.Container(
          color: PdfColor.fromHex('#9B9B9B'),
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
                    color: PdfColor.fromHex('#ffffff'),
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
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
                    fontSize: fontSize,
                  ),
                )),
              )),
        ),
      ]),
      // card
      pw.TableRow(children: [
        pw.Container(
          color: PdfColor.fromHex('#9B9B9B'),
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
                    color: PdfColor.fromHex('#ffffff'),
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
                  ),
                )),
              )),
        ),
        pw.Container(
          color: PdfColor.fromHex('#9B9B9B'),
          alignment: pw.Alignment.center,
          child: pw.Padding(
              padding:
                  pw.EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: pw.SizedBox(
                height: 12,
              )),
        ),
        pw.Container(
          color: PdfColor.fromHex('#9B9B9B'),
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
                    color: PdfColor.fromHex('#ffffff'),
                    fontWeight: pw.FontWeight.bold,
                    fontSize: fontSize,
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
                    fontSize: fontSize,
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
                    fontSize: fontSize,
                  ),
                )),
              )),
        ),
      ]),
}