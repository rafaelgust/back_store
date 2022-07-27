import 'package:back_store/src/core/services/encrypt/encrypt_service.dart';
import 'package:intl/intl.dart';

import '../datasource/user_datasource.dart';
import '../models/user_model.dart';

abstract class UserRepository {
  final UserDatasource datasource;
  final EncryptService encrypt;

  UserRepository(this.datasource, this.encrypt);

  Future<String> createUser(Map<String, dynamic> userData);
  Future<String> updateUser(Map<String, dynamic> userData);
  Future<void> deleteUser(int id);
  Future<String> getUser(int id);
  Future<String> getListUser();
}

class UserRepositoryImp implements UserRepository {
  @override
  final UserDatasource datasource;

  @override
  final EncryptService encrypt;

  UserRepositoryImp(this.datasource, this.encrypt);

  @override
  Future<String> createUser(Map<String, dynamic> userData) async {
    String timeNow =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'").format(DateTime.now());

    userData.addAll({'created_at': timeNow, 'modified_at': timeNow});
    userData['password'] = encrypt.generateHash(userData['password']);

    final insert = await datasource.insertUser(userData);
    return UserModel.fromMap(insert!).toJson();
  }

  @override
  Future<String> updateUser(Map<String, dynamic> userData) async {
    String timeNow =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'").format(DateTime.now());
    userData.addAll({'modified_at': timeNow});

    final updatedColumns = userData.keys
        .where((key) => key != 'id')
        .where((key) => key != 'password')
        .map((key) => '$key=@$key')
        .toList();

    final insert = await datasource.updateUser(updatedColumns, userData);
    return UserModel.fromMap(insert!).toJson();
  }

  @override
  Future<void> deleteUser(int id) async {
    await datasource.deleteById(id);
  }

  @override
  Future<String> getUser(int id) async {
    final user = await datasource.selectUserById(id);

    return UserModel.fromMap(user!).toJson();
  }

  @override
  Future<String> getListUser() async {
    final users = await datasource.selectUsers();

    final list = users.map((e) => UserModel.fromMap(e!)).toList();

    return list.map((e) => e.toJson()).toList().toString();
  }
}
