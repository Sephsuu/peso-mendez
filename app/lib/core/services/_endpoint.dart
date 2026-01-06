import 'dart:convert';

import 'package:http/http.dart' as http;

// const BASE_URL = 'https://peso-mendez-app-k2283.ondigitalocean.app';
const BASE_URL = 'https://x848qg05-3005.asse.devtunnels.ms';
// const BASE_URL = 'http://localhost:3005';

Future<dynamic> request(
  String endpoint, 
  { String method = 'GET', dynamic customHeader, Map<String, dynamic>? body }
) async {
  final url = Uri.parse(endpoint);
  final headers = {'Content-Type': 'application/json'};
  if (customHeader != null && customHeader is Map<String, String>) {
    headers.addAll(customHeader);
  }
  late http.Response res;
  print('Endpoint: $endpoint');
  print('Headers: $headers');

  try {
    switch (method) {
      case 'POST':
        print('Method: POST');
        if (body != null) {
          res = await http.post(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
        } else {
          res = await http.post(url, headers: headers); // No body
        }
        break;
      case 'PUT':
        print('Method: PUT'); 
        if (body != null) {
          res = await http.put(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
        } else {
          res = await http.put(url, headers: headers); // No body
        }
        break;
      case 'PATCH':
        print('Method: PATCH');
        if (body != null) {
          res = await http.patch(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
        } else {
          res = await http.patch(url, headers: headers); // No body
        }
        break;
      case 'DELETE':
        print('Method: DELETE'); 
        if (body != null) {
          res = await http.delete(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
        } else {
          res = await http.delete(url, headers: headers); // No body
        }
        break;
      default:
        print('Method: GET');
        res = await http.get(url, headers: headers);
    }
    print('Body: ${jsonEncode(body)}');
    print('Response Code: ${res.statusCode}');

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;

      final decoded = jsonDecode(res.body);
      print('Response Body: ${jsonDecode(res.body)}');
      if (decoded is List) {
        return decoded.map((e) => e as Map<String, dynamic>).toList();
      }
      return decoded;
    } else if (res.statusCode == 404) {
      return null;
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('Request failed: $e');
  }
}

