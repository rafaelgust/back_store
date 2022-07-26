import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'package:back_store/src/core/services/database/database_service.dart';
import 'package:back_store/src/core/services/encrypt/encrypt_service.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/auth/login', _login),
        Route.get('/auth/check_token', _checkToken),
        Route.get('/auth/refresh_token', _refreshToken),
        Route.get('/auth/update_password', _updatePassword),
      ];
}

FutureOr<Response> _login(Injector injector) async {
  final database = injector.get<RemoteDatabase>();
  final encrypt = injector.get<EncryptService>();

  return Response.ok('');
}

FutureOr<Response> _checkToken(Injector injector) async {
  final database = injector.get<RemoteDatabase>();
  final encrypt = injector.get<EncryptService>();

  return Response.ok('');
}

FutureOr<Response> _refreshToken(Injector injector) async {
  final database = injector.get<RemoteDatabase>();
  final encrypt = injector.get<EncryptService>();

  return Response.ok('');
}

FutureOr<Response> _updatePassword(Injector injector) async {
  final database = injector.get<RemoteDatabase>();
  final encrypt = injector.get<EncryptService>();

  return Response.ok('');
}
