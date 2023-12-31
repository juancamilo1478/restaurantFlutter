import 'package:flutter/material.dart';
import 'package:flutter_restaurant/content/tables/DeleteSector.dart';
import 'package:flutter_restaurant/content/tables/TableSelect.dart';
import 'package:flutter_restaurant/content/tables/createSector.dart';
import 'package:flutter_restaurant/content/tables/edidSector.dart';
import 'package:flutter_restaurant/models/sectors.dart';
import 'package:flutter_restaurant/models/selectorSector.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class datasTables extends StatefulWidget {
  @override
  State<datasTables> createState() => _datasTablesState();
}

//
class _datasTablesState extends State<datasTables> {
  late Future<List<Sectors>> listTables;
  late Future<List<selectorSector>> listSectors;
  String? _inputValue;
// list Datas SECTORS
  Future<List<Sectors>> _getSectors(String searchSector) async {
    final Uri url =
        Uri.parse('http://localhost:3001/tables?name=$searchSector');
    final response = await http.get(url);
    final List<Sectors> _sectors = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      jsonData.forEach((key, value) {
        var sectorDataList = value['data'];
        if (sectorDataList is List<dynamic>) {
          List<SectorData> sectorData = sectorDataList.map((item) {
            return SectorData(item['id'], item['state'], item['name'],
                item['categorie'], item['accountId']);
          }).toList();

          _sectors.add(
            Sectors(
              value['x'],
              value['y'],
              sectorData,
            ),
          );
        }
      });

      return _sectors;
    } else {
      throw Exception('Error en la solicitud');
    }
  }

//sectors action
  Future<List<selectorSector>> getAllSectors() async {
    final Uri url = Uri.parse('http://localhost:3001/sectors');
    final response = await http.get(
      url,
    );
    final List<selectorSector> _sectors = [];

    if (response.statusCode == 201) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var item in jsonData) {
        _sectors.add(selectorSector(
          item['id'],
          item['name'],
          item['x'],
          item['y'],
        ));
      }
      return _sectors;
    } else {
      throw Exception("Failed to fetch sectors");
    }
  }

  @override
  void initState() {
    _inputValue = '';
    listTables = _getSectors(_inputValue ?? '');
    listSectors = getAllSectors();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //////////////////////////////////controller filters/////////////////////////////////
        Container(
          color: const Color.fromARGB(255, 52, 53, 53),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                ),
                child: FutureBuilder<List<selectorSector>>(
                  future: listSectors,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return DropdownButton<String>(
                          value: _inputValue,
                          items: _listSectors(snapshot.data ?? []),
                          onChanged: (value) {
                            setState(() {
                              _inputValue = value;
                              listTables = _getSectors(_inputValue!);
                            });
                          },
                          dropdownColor: Colors.grey,
                        );
                      } else {
                        return Text('No data available');
                      }
                    }

                    return Container();
                  },
                ),
              ),
              /////////////////////////////create zones///////////////////////////
              Container(
                height: 50,
                color: const Color.fromARGB(255, 52, 53, 53),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        'Crear Sector',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CreateSectorDialog();
                            },
                          );
                          setState(() {
                            listTables = _getSectors(_inputValue ?? '');
                            listSectors = getAllSectors();
                          });
                        },
                        child: Icon(
                          Icons.add_circle,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ///////////////////////list zones//////////////////////
        Container(
          padding: EdgeInsets.all(100),
          child: FutureBuilder<List<Sectors>>(
            future: listTables,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<Widget> sectorCards = [];
                  for (int index = 0; index < snapshot.data!.length; index++) {
                    Sectors sector = snapshot.data![index];
                    if (sector.data.isNotEmpty) {
                      sectorCards.add(
                        Card(
                          color: Color.fromARGB(176, 60, 61, 63),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      sector.data[0].categorie,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                EditSector(
                                                    sectorsData: snapshot
                                                        .data![index].data,
                                                    xData: sector.x),
                                          );
                                          setState(() {
                                            listTables =
                                                _getSectors(_inputValue ?? '');
                                            listSectors = getAllSectors();
                                          });
                                        },
                                        child: Icon(Icons.edit_rounded)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  DeleteSector(
                                                      context,
                                                      sector
                                                          .data[0].categorie));
                                          setState(() {
                                            listTables =
                                                _getSectors(_inputValue ?? '');
                                            listSectors = getAllSectors();
                                          });
                                        },
                                        child: Icon(Icons.delete))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 400,
                                width: 400,
                                child: GridView.count(
                                  crossAxisCount: sector.x,
                                  children: _listTablesDatas(sector.data, () {
                                    setState(() {
                                      listTables =
                                          _getSectors(_inputValue ?? '');
                                      listSectors = getAllSectors();
                                    });
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                  return Column(
                    children: sectorCards,
                  );
                } else {
                  return Text('No data available');
                }
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

/////////filter options////////////////
  List<DropdownMenuItem<String>> _listSectors(
    List<selectorSector> data,
  ) {
    List<DropdownMenuItem<String>> sector = [];
    sector.add(DropdownMenuItem(
      child: Text(
        'all',
        style: TextStyle(color: Colors.white),
      ),
      value: '',
    ));
    for (var section in data) {
      sector.add(DropdownMenuItem(
        value: section.name,
        child: Text(
          section.name,
          style: TextStyle(color: Colors.white),
        ),
      ));
    }

    return sector;
  }
  //listTables

  List<Widget> _listTablesDatas(List<SectorData> data, Function() refresh) {
    List<Widget> _datas = [];
    for (var element in data) {
      _datas.add(TableSelect(data: element, refresh: refresh));
    }
    return _datas;
  }
}
