import 'package:flutter/material.dart';
import 'package:flutter_restaurant/Responsive/table.dart';
import 'package:flutter_restaurant/constant/constant.dart';
import 'package:flutter_restaurant/content/history/history.dart';
import 'package:flutter_restaurant/content/inventory/inventory.dart';
import 'package:flutter_restaurant/content/tables/index.dart';
import 'package:flutter_restaurant/content/waiters/index.dart';
import 'package:flutter_restaurant/content/total/winnings.dart';

class Deskatop extends StatefulWidget {
  const Deskatop({Key? key}) : super(key: key);

  @override
  State<Deskatop> createState() => _DeskatopState();
}

class _DeskatopState extends State<Deskatop> {
  int _selectedPage = 1;
  List<Widget> _pages = [
    inventory(),
    Tables(),
    winnings(),
    waiters(),
    historyAccounts()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myDefaultbackground,
      appBar: myAppbar,
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Drawer(
            backgroundColor: Colors.grey[300],
            child: Column(
              children: [
                DrawerHeader(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Icons.restaurant),
                      SizedBox(width: 20),
                      Text("Restaurante los amigos"),
                    ],
                  ),
                ),
                ListTile(
                    leading: Icon(Icons.home),
                    title: Text('I N V E N T A R I O'),
                    onTap: () => setState(() {
                          _selectedPage = 0;
                        }),
                    tileColor: _selectedPage == 0 ? Colors.blue[200] : null),
                ListTile(
                    leading: Icon(Icons.table_bar),
                    title: Text('M E S A S'),
                    onTap: () => setState(() {
                          _selectedPage = 1;
                        }),
                    tileColor: _selectedPage == 1 ? Colors.blue[200] : null),
                ListTile(
                  tileColor: _selectedPage == 2 ? Colors.blue[200] : null,
                  leading: Icon(Icons.monetization_on),
                  title: Text('G A N A N C I A S'),
                  onTap: () => setState(() {
                    _selectedPage = 2;
                  }),
                ),
                ListTile(
                  tileColor: _selectedPage == 3 ? Colors.blue[200] : null,
                  leading: Icon(Icons.person_sharp),
                  title: Text('M E S E R O S'),
                  onTap: () => setState(() {
                    _selectedPage = 3;
                  }),
                ),
                ListTile(
                  tileColor: _selectedPage == 4 ? Colors.blue[200] : null,
                  leading: Icon(Icons.history),
                  title: Text('H I S T O R I A L'),
                  onTap: () => setState(() {
                    _selectedPage = 4;
                  }),
                ),
              ],
            ),
          ),
          _pages[_selectedPage ?? 0],
        ],
      ),
    );
  }
}
