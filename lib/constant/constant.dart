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

var myDrawer = Drawer(
  backgroundColor: Colors.grey[300],
  child: Column(
    children: [
      DrawerHeader(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.restaurant),
            SizedBox(
              width: 20,
            ),
            Text("Restaurante los amigos")
          ],
        ),
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: Text('I N V E N T A R I O'),
      ),
      ListTile(
        leading: Icon(Icons.table_bar),
        title: Text('M E S A S'),
      ),
      ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text('G A N A N C I A S'),
      ),
      ListTile(
        leading: Icon(Icons.person_sharp),
        title: Text('M E S E R O S'),
      ),
    ],
  ),
);

var myDefaultbackground = Colors.grey[300];
