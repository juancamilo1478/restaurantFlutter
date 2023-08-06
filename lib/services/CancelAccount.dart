import 'package:http/http.dart' as http;

Future<String> CanceledAccount(int idAccount, int idTable) async {
  print(idAccount);
  print(idTable);
  final Uri url =
      Uri.parse('http://localhost:3001/accounts/$idAccount?tableId=$idTable');
  final response = await http.delete(url);

  if (response.statusCode == 201) {
    // Si el código de estado es 201 (Éxito), retornamos un mensaje de éxito
    return 'Cuenta cancelada con éxito.';
  } else {
    // Si hay un error, retornamos el mensaje descriptivo del estado de la respuesta
    return 'Error: ${response.reasonPhrase}';
  }
}
