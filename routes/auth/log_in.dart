import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dart_frog/dart_frog.dart';
import '../../api/api.dart'; 

Future<Response> onRequest(RequestContext context) async {
  final requestBody = await context.request.body();
  final Map<String, dynamic> data = json.decode(requestBody) as Map<String, dynamic>;

  final email = data['email'];
  final password = data['password'];

  if (email == null || password == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Email and password are required.'},
    );
  }
  final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    final idToken = responseBody['idToken'];

    return Response.json(
      statusCode: 200,
      body: {'message': 'Log-in successful', 'idToken': idToken},
    );
  } else {
    final errorBody = json.decode(response.body);
    return Response.json(
      statusCode: 500,
      body: {'error': 'Log-in failed', 'message': errorBody['error']['message']},
    );
  }
}
