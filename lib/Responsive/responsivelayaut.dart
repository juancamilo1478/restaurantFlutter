import 'package:flutter/material.dart';

class layout extends StatelessWidget {
  final Widget mobilScaffold;
  final Widget tablesScafold;
  final Widget desktopScaffold;
  layout({
    required this.mobilScaffold,
    required this.desktopScaffold,
    required this.tablesScafold,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return mobilScaffold;
        } else if (constraints.maxWidth < 1100) {
          return tablesScafold;
        } else {
          return desktopScaffold;
        }
      },
    );
  }
}
