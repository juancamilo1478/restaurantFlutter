import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> finishAccount(
  int idAccount,
  int idTable,
  num box,
  num card,
  num propine,
) async {
  // int box, int card
  final url = Uri.http('localhost:3001', '/accounts/pay');
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'idAccount': idAccount,
      'idTable': idTable,
      'box': box.toInt(),
      'card': card.toInt(),
      'propine': propine
    }),
  );
  if (response.statusCode == 200) {
    return 'Completado';
  } else {
    return 'Error';
  }
}
