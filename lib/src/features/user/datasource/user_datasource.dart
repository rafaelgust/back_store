import 'package:back_store/src/core/services/database/database_service.dart';

import '../exceptions/user_exception.dart';

abstract class UserDatasource {
  final RemoteDatabase database;

  UserDatasource(this.database);

  Future<Map<String, dynamic>?> insertUser(
      Map<String, dynamic> userDataToInsert);
  Future<Map<String, dynamic>?> updateUser(
    List<String> updatedColumns,
    Map<String, dynamic> userDataToUpdate,
  );
  Future<void> deleteById(int id);
  Future<List<Map<String, dynamic>?>> selectUsers();
  Future<Map<String, dynamic>?> selectUserById(int id);
}

class UserDatasourcePostgreSQL implements UserDatasource {
  @override
  final RemoteDatabase database;

  UserDatasourcePostgreSQL(this.database);

  @override
  Future<Map<String, dynamic>?> insertUser(
      Map<String, dynamic> userDataToInsert) async {
    final query = await database.query(
      'INSERT INTO public.users(email, password, first_name, last_name, created_at)	VALUES ( @email , @password , @first_name , @last_name, @created_at) RETURNING id, email, first_name, last_name, created_at, modified_at;',
      variables: userDataToInsert,
    );

    if (query.isEmpty) {
      throw UserException(404, 'ERROR INSERT');
    }

    return query.map((e) => e['users']).first;
  }

  @override
  Future<Map<String, dynamic>?> updateUser(
    List<String> updatedColumns,
    Map<String, dynamic> userDataToUpdate,
  ) async {
    final query = await database.query(
      'UPDATE "users" SET ${updatedColumns.join(',')} WHERE id = @id RETURNING id, email, first_name, last_name, created_at, modified_at;',
      variables: userDataToUpdate,
    );

    if (query.isEmpty) {
      throw UserException(404, 'ERROR UPDATE');
    }

    return query.map((e) => e['users']).first;
  }

  @override
  Future<void> deleteById(int id) async {
    try {
      await database.query(
        'DELETE FROM "users" WHERE id = @id',
        variables: {'id': id},
      );
    } on UserException catch (e) {
      throw UserException(e.statusCode, e.toJson());
    }
  }

  @override
  Future<List<Map<String, dynamic>?>> selectUsers() async {
    final query = await database.query(
      'SELECT id, email, first_name, last_name, created_at, modified_at FROM "users" ORDER BY id ASC;',
    );

    if (query.isEmpty) {
      throw UserException(404, 'ERROR LIST USERS');
    }

    return query.map((e) => e['users']).toList();
  }

  @override
  Future<Map<String, dynamic>?> selectUserById(int id) async {
    final query = await database.query(
      'SELECT id, email, first_name, last_name, created_at, modified_at	FROM "users" WHERE id = @id',
      variables: {'id': id},
    );

    if (query.isEmpty) {
      throw UserException(404, 'ERROR FND USER');
    }

    return query.map((e) => e['users']).first;
  }
}
