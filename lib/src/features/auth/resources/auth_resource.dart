import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'package:back_store/src/core/services/request_extractor/request_extractor_service.dart';
import 'package:back_store/src/core/services/database/database_service.dart';
import 'package:back_store/src/core/services/encrypt/encrypt_service.dart';
import 'package:back_store/src/core/services/jwt/jwt_service.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/auth/login', _login),
        Route.get('/auth/check_token', _checkToken),
        Route.get('/auth/refresh_token', _refreshToken),
        Route.get('/auth/update_password', _updatePassword),
      ];

  FutureOr<Response> _login(Request request, Injector injector) async {
    final extractor = injector.get<RequestExtractor>();
    final database = injector.get<RemoteDatabase>();
    final encrypt = injector.get<EncryptService>();
    final jwt = injector.get<JwtService>();
    final credentials = extractor.getAuthorizationBasic(request);

    final query = await database.query(
      'SELECT id, password	FROM "users" WHERE email = @email',
      variables: {'email': credentials.email},
    );

    if (query.isEmpty) {
      return Response.forbidden(
        jsonEncode({'error': 'email or password invalid'}),
      );
    }

    final user = query.map((e) => e['users']).first!;

    if (!encrypt.checkHash(credentials.password, user['password'])) {
      return Response.forbidden(
        jsonEncode({'error': 'email or password invalid'}),
      );
    }

    final payload = user..remove('password');
    payload['exp'] = _expiration(Duration(minutes: 5));

    final accessToken = jwt.generateToken(payload, 'accessToken');

    payload['exp'] = _expiration(Duration(days: 3));
    final refreshToken = jwt.generateToken(payload, 'refreshToken');

    return Response.ok(
      jsonEncode({
        'access_token': accessToken,
        'refresh_token': refreshToken,
      }),
    );
  }

  FutureOr<Response> _checkToken(Injector injector) async {
    return Response.ok('');
  }

  FutureOr<Response> _refreshToken(Injector injector) async {
    return Response.ok('');
  }

  FutureOr<Response> _updatePassword(Injector injector) async {
    return Response.ok('');
  }

  int _expiration(Duration duration) {
    final expiresDate = DateTime.now().add(Duration(seconds: 30));
    return Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;
  }
}
