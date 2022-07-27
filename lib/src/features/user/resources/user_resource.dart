import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../guard/user_guard.dart';

import '../exceptions/user_exception.dart';

import '../repositories/user_repository.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/', _getUsers),
        Route.get('/:id', _getuserById),
        Route.post('/', _createuser),
        Route.put('/', _updateuser, middlewares: [UserGuard()]),
        Route.delete('/:id', _deleteuser, middlewares: [UserGuard()]),
      ];
}

FutureOr<Response> _getUsers(Injector injector) async {
  final repository = injector.get<UserRepository>();

  try {
    final json = await repository.getListUser();
    return Response.ok(json, headers: {"Content-Type": "application/json"});
  } on UserException catch (e) {
    return Response(
      e.statusCode,
      headers: {"Content-Type": "application/json"},
      body: e.toJson(),
    );
  }
}

FutureOr<Response> _getuserById(
    ModularArguments arguments, Injector injector) async {
  final repository = injector.get<UserRepository>();
  final id = int.parse(arguments.params['id']);

  try {
    final json = await repository.getUser(id);
    return Response.ok(json, headers: {"Content-Type": "application/json"});
  } on UserException catch (e) {
    return Response(
      e.statusCode,
      headers: {"Content-Type": "application/json"},
      body: e.toJson(),
    );
  }
}

FutureOr<Response> _createuser(
  ModularArguments arguments,
  Injector injector,
) async {
  final repository = injector.get<UserRepository>();
  var userData = (arguments.data as Map).cast<String, dynamic>();
  try {
    final json = await repository.createUser(userData);
    return Response.ok(json, headers: {"Content-Type": "application/json"});
  } on UserException catch (e) {
    return Response(
      e.statusCode,
      headers: {"Content-Type": "application/json"},
      body: e.toJson(),
    );
  }
}

FutureOr<Response> _updateuser(
  Request request,
  ModularArguments arguments,
  Injector injector,
) async {
  final repository = injector.get<UserRepository>();
  var userData = (arguments.data as Map).cast<String, dynamic>();

  try {
    final json = await repository.updateUser(userData);
    return Response.ok(json, headers: {"Content-Type": "application/json"});
  } on UserException catch (e) {
    return Response(
      e.statusCode,
      headers: {"Content-Type": "application/json"},
      body: e.toJson(),
    );
  }
}

FutureOr<Response> _deleteuser(
  Request request,
  ModularArguments arguments,
  Injector injector,
) async {
  final repository = injector.get<UserRepository>();
  final id = int.parse(arguments.params['id']);
  await repository.deleteUser(id);

  return Response.ok(
    jsonEncode({"message": "User $id has been deleted"}),
    headers: {"Content-Type": "application/json"},
  );
}
