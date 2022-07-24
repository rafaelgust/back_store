import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'package:back_store/src/core/services/database/database_service.dart';

import '../models/user_model.dart';

class UsersResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/users', _getUsers),
        Route.get('/user/:id', _getuserById),
        Route.post('/user', _createuser),
        Route.put('/user', _updateuser),
        Route.delete('/user/:id', _deleteuser),
      ];
}

FutureOr<Response> _getUsers(Injector injector) async {
  final database = injector.get<RemoteDatabase>();
  final query = await database.query(
      'SELECT id, email, first_name, last_name, created_at, modified_at FROM "users" ORDER BY id ASC;');

  final result = query.map((e) => e['users']).toList();
  final list = result.map((e) => UserModel.fromMap(e!)).toList();

  String toJson = list.map((e) => e.toJson()).toList().toString();

  return Response.ok(toJson, headers: {"Content-Type": "application/json"});
}

FutureOr<Response> _getuserById(
    ModularArguments arguments, Injector injector) async {
  final id = arguments.params['id'];
  final database = injector.get<RemoteDatabase>();
  final query = await database.query(
    'SELECT id, email, first_name, last_name, created_at, modified_at	FROM "users" WHERE id = @id',
    variables: {'id': id},
  );
  final result = query.map((e) => e['users']).first;
  final toJson = UserModel.fromMap(result!).toJson();

  return Response.ok(toJson, headers: {"Content-Type": "application/json"});
}

FutureOr<Response> _createuser(
    ModularArguments arguments, Injector injector) async {
  var userData = (arguments.data as Map).cast<String, dynamic>();
  userData.addAll({
    'created_at':
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'").format(DateTime.now())
  });

  final database = injector.get<RemoteDatabase>();
  final query = await database.query(
    'INSERT INTO public.users(email, password, first_name, last_name, created_at)	VALUES ( @email , @password , @first_name , @last_name, @created_at) RETURNING id, email, first_name, last_name, created_at, modified_at;',
    variables: userData,
  );
  final result = query.map((e) => e['users']).first;
  final toJson = UserModel.fromMap(result!).toJson();

  return Response.ok(toJson, headers: {"Content-Type": "application/json"});
}

FutureOr<Response> _updateuser(
    ModularArguments arguments, Injector injector) async {
  final database = injector.get<RemoteDatabase>();
  var userData = (arguments.data as Map).cast<String, dynamic>();

  userData.addAll({
    'modified_at':
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'").format(DateTime.now())
  });

  final updatedColumns = userData.keys
      .where((key) => key != 'id')
      .where((key) => key != 'password')
      .map((key) => '$key=@$key')
      .toList();

  final query = await database.query(
    'UPDATE "users" SET ${updatedColumns.join(',')} WHERE id = @id RETURNING id, email, first_name, last_name, created_at, modified_at;',
    variables: userData,
  );

  final result = query.map((e) => e['users']).first;
  final toJson = UserModel.fromMap(result!).toJson();

  return Response.ok(toJson, headers: {"Content-Type": "application/json"});
}

FutureOr<Response> _deleteuser(
    ModularArguments arguments, Injector injector) async {
  final id = arguments.params['id'];
  final database = injector.get<RemoteDatabase>();
  await database
      .query('DELETE FROM "users" WHERE id = @id', variables: {'id': id});

  return Response.ok(jsonEncode('{"message": "User $id has deleted"}'),
      headers: {"Content-Type": "application/json"});
}
