import 'package:back_store/src/core/services/jwt/jwt_service.dart';
import 'package:back_store/src/core/services/request_extractor/request_extractor_service.dart';

import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'package:shelf_modular/shelf_modular.dart';

class AuthGuard extends ModularMiddleware {
  @override
  Handler call(Handler handler, [ModularRoute? route]) {
    final extractor = Modular.get<RequestExtractor>();
    final jwt = Modular.get<JwtService>();

    return (request) {
      if (!request.headers.containsKey('authorization')) {
        return Response.forbidden(jsonEncode({'error': 'Not Authorization'}));
      }

      final token = extractor.getAuthorizationBearer(request);

      try {
        jwt.verifyToken(token, 'accessToken');
        return handler(request);
      } catch (e) {
        return Response.forbidden(jsonEncode({'error': e.toString()}));
      }
    };
  }
}
