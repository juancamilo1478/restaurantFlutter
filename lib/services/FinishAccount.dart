import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> finishAccount(
    int idAccount, int idTable, String type, num propine) async {
  final url = Uri.http('localhost:3001', '/accounts/pay');
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'type': type,
      'idAccount': idAccount,
      'idTable': idTable,
      'propine': propine
    }),
  );
  if (response.statusCode == 200) {
    return 'Completado';
  } else {
    return 'Error';
  }
}
