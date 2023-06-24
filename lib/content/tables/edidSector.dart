import 'package:flutter/material.dart';
import 'package:flutter_restaurant/models/sectors.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditSector extends StatefulWidget {
  final List<SectorData> sectorsData;
  final int xData;
  final Function refreh;
  const EditSector(
      {required this.sectorsData, required this.xData, this.refreh});

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
    widgets.add(OneTable(data: element));
  }
  return widgets;
}

class OneTable extends HookWidget {
  final SectorData data;

  const OneTable({required this.data});

  @override
  Widget build(BuildContext context) {
    final state = useState(data.state);
    final name = useState(data.name);
    final id = data.id;
    final isHovered = useState(false);
    Widget icon = Icon(
      Icons.table_bar,
      color: state.value == 'Onn' ? Colors.green : Colors.red,
    );

    if (isHovered.value) {
      icon = Tooltip(
        message: 'Estado: ${state.value} Nombre:${data.name}',
        child: icon, // Cambiado a 'icon' en lugar de 'Icon'
      );
    }
    return InkWell(
      onTap: () {
        // if (state.value == 'Off') {
        //   state.value = 'Onn';
        // } else {
        //   state.value = 'Off';
        // }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: EditElement(
                id: id,
                name: name.value,
                state: state.value,
              ),
            );
          },
        );
      },
      child: MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) => isHovered.value = false,
        child: isHovered.value == true
            ? icon // Cambiado a 'icon' en lugar de 'Icon'
            : Icon(
                Icons.table_bar,
                color: state.value == 'Onn' ? Colors.green : Colors.red,
              ),
      ),
    );
  }
}

//edid element
class EditElement extends StatefulWidget {
  final int id;
  final String name;
  final String state;

  const EditElement(
      {required this.id, required this.name, required this.state});

  @override
  _EditElementState createState() => _EditElementState();
}

class _EditElementState extends State<EditElement> {
  TextEditingController _nameController = TextEditingController();
  String? _selectedState;
  String? _name;

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
                  maxLength: 30,
                  controller: _nameController,
                  onChanged: (value) {
                    setState(() {
                      // Actualizar el valor del nombre
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
            // Acciones para guardar los cambios
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
                print('YA');
              } else {
                // Fluttertoast.showToast(
                //   msg: 'Error al cambiar el producto',
                //   toastLength: Toast.LENGTH_SHORT,
                //   gravity: ToastGravity.BOTTOM,
                //   backgroundColor: Colors.black87,
                //   textColor: Colors.white,
                //   timeInSecForIosWeb: 2,
                // );
                Navigator.of(context).pop();
              }
            } else {
              Navigator.of(context).pop();
            }

            Navigator.of(context).pop();
          },
          child: Text('Guardar'),
        ),
        TextButton(
          onPressed: () {
            // Acciones para cancelar los cambios
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}
