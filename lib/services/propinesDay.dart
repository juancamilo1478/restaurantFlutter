import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> allPropineDay(
  String date,
) async {
  final url = Uri.http('localhost:3001', '/waiter/day/allpropines');
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'date': date,
    }),
  );

  if (response.statusCode == 200) {
    // Decodificar el JSON en un mapa
    Map<String, dynamic> responseData = jsonDecode(response.body);

    // Acceder a la propiedad "total" del mapa
    if (responseData.containsKey('total')) {
      return responseData['total'].toString();
    } else {
      return 'Total not found in response';
    }
  } else {
    return 'Error';
  }
}
