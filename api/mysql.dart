import 'dart:convert';
import 'dart:io';
import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> createConnection() async {
  final configFile = File('json/config.json');
  final configJson = await configFile.readAsString();
  final config = json.decode(configJson);

  final settings = ConnectionSettings(
    host: config['host'],
    port: config['port'],
    user: config['user'],
    password: config['password'],
    db: config['db'],
  );

  final conn = await MySqlConnection.connect(settings);
  return conn;
}
