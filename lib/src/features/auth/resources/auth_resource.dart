import 'package:back_store/src/core/services/request_extractor/request_extractor_service.dart';

import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../exceptions/auth_exceptions.dart';
import '../guard/auth_guard.dart';

import '../repositories/auth_repository.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/login', _login),
        Route.put('/update_password', _updatePassword,
            middlewares: [AuthGuard()]),
        Route.get('/check_token', _checkToken, middlewares: [AuthGuard()]),
        Route.get('/refresh_token', _refreshToken, middlewares: [
          AuthGuard(isRefreshToken: true),
        ]),
      ];

  FutureOr<Response> _login(Request request, Injector injector) async {
    final authRepository = injector.get<AuthRepository>();
    final extractor = injector.get<RequestExtractor>();
    final credentials = extractor.getAuthorizationBasic(request);

    try {
      final tokenization = await authRepository.login(credentials);
      return Response.ok(tokenization.toJson());
    } on AuthExceptions catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _checkToken(Injector injector) async =>
      Response.ok(jsonEncode({'message': 'checked'}));
  //guard middlewares is check the token

  FutureOr<Response> _refreshToken(Request request, Injector injector) async {
    final authRepository = injector.get<AuthRepository>();
    final extractor = injector.get<RequestExtractor>();
    final token = extractor.getAuthorizationBearer(request);

    try {
      final tokenization = await authRepository.refreshToken(token);
      return Response.ok(tokenization.toJson());
    } on AuthExceptions catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _updatePassword(
      Request request, ModularArguments arguments, Injector injector) async {
    final authRepository = injector.get<AuthRepository>();
    final extractor = injector.get<RequestExtractor>();
    final token = extractor.getAuthorizationBearer(request);

    final data = arguments.data as Map;

    try {
      await authRepository.updatePassword(token, data);
      return Response.ok(jsonEncode({'message': 'success'}));
    } on AuthExceptions catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }
}
