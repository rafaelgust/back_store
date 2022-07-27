import 'package:back_store/src/core/services/database/database_service.dart';

import 'package:intl/intl.dart';

import '../exceptions/auth_exceptions.dart';

abstract class AuthDatasource {
  final RemoteDatabase database;

  AuthDatasource(this.database);

  Future<Map> getIdByEmail(String email);
  Future<Map> verifyIdById(int id);
  Future<String> getHashPassById(int id);
  Future<void> updatePasswordById(int id, String newPassword);
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

  @override
  Future<Map> verifyIdById(int id) async {
    final query = await database.query(
      'SELECT id FROM "users" WHERE id = @id',
      variables: {'id': id},
    );

    if (query.isEmpty) {
      throw AuthExceptions(403, 'id invalid');
    }

    return query.map((e) => e['users']).first!;
  }

  @override
  Future<String> getHashPassById(int id) async {
    final query = await database.query(
      'SELECT password FROM "users" WHERE id = @id',
      variables: {'id': id},
    );
    if (query.isEmpty) {
      throw AuthExceptions(403, 'Id is invalid');
    }

    return query.map((e) => e['users']).first!['password'];
  }

  @override
  Future<void> updatePasswordById(int id, String newPassword) async {
    String modifiedAt =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'").format(DateTime.now());

    try {
      await database.query(
        'UPDATE "users" SET password = @newPassword, modified_at = @modifiedAt WHERE id = @id',
        variables: {
          'id': id,
          'newPassword': newPassword,
          'modifiedAt': modifiedAt,
        },
      );
    } on AuthExceptions catch (e) {
      throw AuthExceptions(e.statusCode, e.toJson());
    }
  }
}
