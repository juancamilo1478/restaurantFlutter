import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/content/history/editAccountHistory.dart';
import 'package:flutter_restaurant/models/Account.dart';
import 'package:http/http.dart' as http;

class historyAccounts extends StatefulWidget {
  const historyAccounts({super.key});

  @override
  State<historyAccounts> createState() => _historyAccountsState();
}

class _historyAccountsState extends State<historyAccounts> {
  @override
  int page = 1;
  List<Widget> pageButtons = [];
  int? accountId = null;
  DateTime? selectedDate;
  String? DateDay = null;
  late Future<List<AccountBasic>> AccountsList = Future.value([]);
  String _search = '';
  //action seach Accounts
  Future<List<AccountBasic>> _Accounts(
      int? page, String? dated, int? id) async {
    try {
      String search = '';
      if (dated != null && dated != '') {
        search +=
            "&date=$dated"; // Agrega fecha si dated no es nulo ni cadena vacía
      }
      if (id != null && id != '') {
        search +=
            "&accountId=$id"; // Agrega accountId si id no es nulo ni cadena vacía
      }

      final Uri url = Uri.parse(
          'http://localhost:3001/accounts/paginade?pageNumber=${page.toString()}${search}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        final List<AccountBasic> accountslist = [];
        final List<Widget> paginadeNumbers = [];
        for (var item in jsonData['accounts']) {
          accountslist.add(AccountBasic(
              id: item['id'],
              card: item['card'].toString(),
              box: item['box'].toString(),
              date: item['date'].toString(),
              state: item['state'].toString(),
              propine: item['propine'].toString(),
              waitersId: item["WaitersId"],
              tableId: item["TableId"]));
        }
        for (var i = 1; i <= jsonData["totalPages"]; i++) {
          paginadeNumbers.add(
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  //action botton
                  setState(() {
                    page = i;
                    AccountsList = _Accounts(i, dated, id);
                  });
                },
                child: Text("$i"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(page == i
                      ? Colors.green
                      : Colors.blue), // Establece el color de fondo deseado
                ),
              ),
            ),
          );
        }

        setState(() {
          pageButtons = paginadeNumbers;
          page =
              jsonData["currentPage"]; // Asegúrate de usar la variable correcta
        });
        return accountslist;
      } else {
        throw Exception(
            "Fallo la petición: ${jsonDecode(response.body)['error']}");
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Se produjo un error al cargar los datos: $e"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el AlertDialog
                },
                child: Text("Aceptar"),
              ),
            ],
          );
        },
      );
      return []; // O cualquier valor predeterminado que desees devolver en caso de error.
    }
  }

  TextEditingController _idController = TextEditingController();
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Container(
            color: const Color.fromARGB(255, 8, 33, 53),
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 150.0,
                  child: TextField(
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .blue), // Cambiar color del borde cuando el TextField está enfocado
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .grey), // Cambiar color del borde cuando el TextField no está enfocado
                      ),
                      // Otros atributos de decoración
                    ),
                    controller: _idController,
                    onChanged: (value) {
                      if (value != "") {
                        accountId = int.parse(value);
                      } else {
                        accountId = null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  constraints: BoxConstraints(minWidth: 200),
                  child: ElevatedButton(
                      onPressed: () async {
                        await _selectDate(context);
                      },
                      child: DateDay != null
                          ? Text(
                              DateDay.toString(),
                            )
                          : Text("Seleccione fecha")),
                ),
                SizedBox(
                  width: 10,
                ),
                if (DateDay != null)
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors
                            .transparent), // Cambia el color de fondo a azul
                      ),
                      onPressed: () {
                        setState(() {
                          DateDay = null;
                        });
                      },
                      child: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      )),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        page = 1;
                        AccountsList = _Accounts(page, DateDay, accountId);
                      });
                    },
                    child: Text("Buscar"))

                // Puedes agregar más widgets a la fila aquí
              ],
            ),
          ),
          if (AccountsList != [])
            Container(
              child: FutureBuilder(
                  future: AccountsList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DataTable(
                        columns: [
                          DataColumn(label: Text('Id')),
                          DataColumn(label: Text('Estado')),
                          DataColumn(label: Text('Caja')),
                          DataColumn(label: Text('Tarjeta')),
                          DataColumn(label: Text('Fecha')),
                          DataColumn(
                              label: Row(
                            children: [Text('Editar')],
                          )),
                        ],
                        rows: _AccountsRows(snapshot.data ?? []),
                      );
                      // Agrega el widget que deseas mostrar aquí
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text(
                          "Error al obtener los datos"); // Agrega el widget de error aquí
                    } else {
                      return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
                    }
                  }),
            ),
          if (pageButtons.isNotEmpty)
            Container(
              padding: EdgeInsets.all(50),
              width: 500, // Ancho fijo del contenedor
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Esto también ayudará a centrar los botones dentro del Row
                  children: pageButtons,
                ),
              ),
            )

          // Aquí puedes agregar más contenido debajo de la fila
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now(), // Fecha inicial al abrir el cuadro de diálogo
      firstDate: DateTime(2021), // Fecha mínima seleccionable
      lastDate: DateTime(2040), // Fecha máxima seleccionable
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        DateDay = '${picked.year}-${picked.month}-${picked.day}';
      });
    }
  }

  List<DataRow> _AccountsRows(List<AccountBasic> data) {
    return data.map((dataAccount) {
      return DataRow(cells: [
        DataCell(Text(dataAccount.id.toString())),
        DataCell(Text(dataAccount.state)),
        DataCell(Text(dataAccount.box.toString())),
        DataCell(Text(dataAccount.card.toString())),
        DataCell(Text(dataAccount.date.toString())),
        DataCell(InkWell(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return editAccountHistory(
                  idAccount: dataAccount.id,
                  date: dataAccount.date,
                  state: dataAccount.state,
                );
              },
            );
          },
          child: Icon(Icons.edit_rounded),
        )),
      ]);
    }).toList();
  }
}
