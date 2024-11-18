import 'package:dart_frog/dart_frog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api/api.dart';
import '../../api/mysql.dart';
import '../../model/users.dart';

Future<Response> onRequest(RequestContext context) async {
  final requestBody = await context.request.body();
  final Map<String, dynamic> data = json.decode(requestBody) as Map<String, dynamic>;

  User user = User.fromJson(data);
  final password = data['password'];

  if (user.email == null || password == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Email and password are required.'},
    );
  }
  final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': user.email,
      'password': password,
      'returnSecureToken': true,
    }),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    final idToken = responseBody['idToken'];
    final id = responseBody['localId'];

    final conn = await createConnection();
    const query = '''
    INSERT INTO users (id, email, phone, role, name)
    VALUES (?, ?, ?, ?, ?)
  ''';
    
    try {
      var result = await conn.query(query, [
        id,
        user.email,
        user.phone,
        user.role,
        user.name
      ]);

      return Response.json(
        statusCode: 200,
        body: {'message': 'User registered successfully', 'idToken': idToken},
      );
    } catch (e) {
      return Response.json(
        statusCode: 500,
        body: {'error': 'Error registering user', 'message': e.toString()},
      );
    } finally {
      await conn.close();
    }

  } else {
    final errorBody = json.decode(response.body);
    return Response.json(
      statusCode: 500,
      body: {'error': 'Register failed', 'message': errorBody['error']['message']},
    );
  }
}
