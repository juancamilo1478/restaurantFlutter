import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/models/sectors.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditSector extends StatefulWidget {
  final List<SectorData> sectorsData;
  final int xData;

  const EditSector({
    required this.sectorsData,
    required this.xData,
  });

  @override
  State<EditSector> createState() => _EditSectorState();
}

class _EditSectorState extends State<EditSector> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Habilita y deshabilita mesas'),
      content: SizedBox(
        height: 400,
        width: 400,
        child: GridView.count(
          crossAxisCount: widget.xData,
          children: _listTablesData(widget.sectorsData),
        ),
      ),
    );
  }
}

List<Widget> _listTablesData(List<SectorData> data) {
  List<Widget> widgets = [];
  for (var element in data) {
    widgets.add(
      OneTable(
        data: element,
      ),
    );
  }
  return widgets;
}

class OneTable extends HookWidget {
  final SectorData data;

  const OneTable({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final state = useState(data.state);
    final name = useState(data.name);
    final id = data.id;
    final category = data.categorie;
    final isHovered = useState(false);
    Widget icon = Icon(
      Icons.table_bar,
      color: state.value == 'On' ? Colors.green : Colors.red,
    );

    if (isHovered.value) {
      icon = Tooltip(
        message: 'Estado: ${state.value} Nombre:${data.name}',
        child: icon,
      );
    }
    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: EditElement(
                id: id,
                name: name.value,
                state: state.value,
                categorie: category,
                onDataChanged: (newData) {
                  name.value = newData.name;
                  state.value = newData.state;
                },
              ),
            );
          },
        );
      },
      child: MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) => isHovered.value = false,
        child: isHovered.value == true
            ? icon
            : Icon(
                Icons.table_bar,
                color: state.value == 'On' ? Colors.green : Colors.red,
              ),
      ),
    );
  }
}

class EditElement extends StatefulWidget {
  final int id;
  final String name;
  final String state;
  final String categorie;
  final Function(SectorData) onDataChanged;

  const EditElement({
    required this.id,
    required this.name,
    required this.state,
    required this.categorie,
    required this.onDataChanged,
  });

  @override
  _EditElementState createState() => _EditElementState();
}

class _EditElementState extends State<EditElement> {
  TextEditingController _nameController = TextEditingController();
  String? _selectedState;
  String? _name;
  String? _categorie;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _selectedState = widget.state;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar elemento'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Nombre'),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  maxLength: 2,
                  controller: _nameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Estado'),
              SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedState,
                items: [
                  DropdownMenuItem(
                    value: 'Off',
                    child: Text('Deshabilitar'),
                  ),
                  DropdownMenuItem(
                    value: 'On',
                    child: Text('Habilitar'),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _selectedState = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_selectedState != widget.state || _name != widget.name) {
              final url = Uri.http('localhost:3001', '/tables');

              final response = await http.put(
                url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  "idTable": widget.id,
                  "state": _selectedState,
                  "name": _name
                }),
              );
              if (response.statusCode == 201) {
                widget.onDataChanged(SectorData(
                    widget.id,
                    _selectedState ?? widget.state,
                    _name ?? widget.name,
                    widget.categorie,
                    1));
                Navigator.of(context).pop();
              } else {
                print(response.body);
                Navigator.of(context).pop();
              }
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Text('Guardar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}
