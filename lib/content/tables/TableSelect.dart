import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_restaurant/content/Accounts/Account.dart';
import 'package:flutter_restaurant/content/tables/addAcount.dart';
import 'package:flutter_restaurant/models/sectors.dart';

class TableSelect extends HookWidget {
  final SectorData data;
  final Function() refresh;
  const TableSelect({required this.data, required this.refresh});

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    final _state = useState(data.state);
    final _name = useState(data.name);

    Widget icon = InkWell(
      onTap: () async {
        if (_state.value == 'On') {
          await showDialog(
              context: context,
              builder: (BuildContext dialogContext) =>
                  AddAccount(idTable: data.id));
          refresh();
        }
        if (_state.value == 'Occupied') {
          await showDialog(
              context: context,
              builder: (BuildContext dialogContext) => AccountScreen(
                    accountId: data.accountId!,
                    nameTable: data.name,
                    nameSector: data.categorie,
                  ));
          refresh();
        }
      },
      child: Center(
        child: Text(
          _name.value,
          style: TextStyle(
            fontSize: 40,
            color: _state.value == 'On'
                ? Colors.green
                : _state.value == 'Occupied'
                    ? Colors.orange
                    : Colors.transparent,
          ),
        ),
      ),
    );

    if (isHovered.value && _state.value == 'On' || _state.value == 'Occupied') {
      icon = Tooltip(
        message: 'Estado: ${_state.value}   Nombre: ${_name.value}',
        child: icon,
      );
    }

    return InkWell(
      onTap: () async {
        // Maneja el evento onTap según tus necesidades
      },
      child: MouseRegion(
          onEnter: (_) => isHovered.value = true,
          onExit: (_) => isHovered.value = false,
          child: isHovered.value
              ? icon
              : Center(
                  child: Text(
                    _name.value,
                    style: TextStyle(
                      fontSize: 40,
                      color: _state.value == 'On'
                          ? Colors.green
                          : _state.value == 'Occupied'
                              ? Colors.orange
                              : Colors.transparent,
                    ),
                  ),
                )),
    );
  }
}
