import 'dart:async';
import 'package:shelf_modular/shelf_modular.dart';
import 'package:postgres/postgres.dart';

import '../dot_env/dot_env_service.dart';

import 'database_service.dart';

class PostgresqlDatabase implements RemoteDatabase, Disposable {
  final completer = Completer<PostgreSQLConnection>();
  final DotEnvService dotEnv;

  void _init() async {
    final uri = Uri.parse(dotEnv['DATABASE_URL']!);
    var connection = PostgreSQLConnection(
      uri.host,
      uri.port,
      uri.pathSegments.first,
      username: uri.userInfo.split(':').first,
      password: uri.userInfo.split(':').last,
    );
    await connection.open();
    completer.complete(connection);
  }

  PostgresqlDatabase(this.dotEnv) {
    _init();
  }

  @override
  void dispose() async {
    final connection = await completer.future;
    await connection.close();
  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> query(
    String queryText, {
    Map<String, dynamic> variables = const {},
  }) async {
    final connection = await completer.future;

    return await connection.mappedResultsQuery(
      queryText,
      substitutionValues: variables,
    );
  }
}
