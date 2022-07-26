import 'package:back_store/src/core/services/database/database_service.dart';

import '../exceptions/auth_exceptions.dart';

abstract class AuthDatasource {
  final RemoteDatabase database;

  AuthDatasource(this.database);

  Future<Map> getIdByEmail(String email);
}

class AuthDatasourcePostgreSQL implements AuthDatasource {
  @override
  final RemoteDatabase database;

  AuthDatasourcePostgreSQL(this.database);

  @override
  Future<Map> getIdByEmail(String email) async {
    final query = await database.query(
      'SELECT id, password	FROM "users" WHERE email = @email',
      variables: {'email': email},
    );

    if (query.isEmpty) {
      throw AuthExceptions(403, 'email or password invalid');
    }

    return query.map((e) => e['users']).first!;
  }
}
