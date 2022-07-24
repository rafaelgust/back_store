import 'dart:async';
import 'dart:convert';
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
      'SELECT id, email, first_name, last_name, created_at, modified_at FROM "users";');

  final result = query.map((e) => e['users']).toList();
  final list = result
      .map(
        (e) => UserModel(
          id: e?.values.elementAt(0),
          email: e?.values.elementAt(1),
          firstName: e?.values.elementAt(2),
          lastName: e?.values.elementAt(3),
          createdAt: e?.values.elementAt(4),
          modifiedAt: e?.values.elementAt(5),
        ),
      )
      .toList();

  String toJson = list.map((e) => e.toJson()).toList().toString();

  return Response.ok(toJson, headers: {"content-type": "application/json"});
}

FutureOr<Response> _getuserById(ModularArguments arguments) {
  return Response.ok('user => ${arguments.params['id']} ok!');
}

FutureOr<Response> _createuser(ModularArguments arguments) {
  return Response.ok('user => Json to create ${arguments.data}');
}

FutureOr<Response> _updateuser(ModularArguments arguments) {
  return Response.ok('user => Json to update ${arguments.data}');
}

FutureOr<Response> _deleteuser(ModularArguments arguments) {
  return Response.ok('user Deleted => ${arguments.params['id']}');
}
