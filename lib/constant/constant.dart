import 'package:flutter/material.dart';

var myAppbar = AppBar(
  backgroundColor: Colors.grey[900],
  centerTitle: true, // Centrar el título y el contenido
  title: Row(
    mainAxisAlignment:
        MainAxisAlignment.center, // Alinear los widgets en el centro
    children: [
      Icon(Icons.restaurant),
      SizedBox(width: 20),
      Text(
        "Restaurante los amigos",
        style: TextStyle(color: Colors.white),
      ),
    ],
  ),
);

var myDefaultbackground = Colors.grey[300];
