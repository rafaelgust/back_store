import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../models/login_model.dart';

abstract class RequestExtractor {
  LoginModel getAuthorizationBasic(Request request);
  String getAuthorizationBearer(Request request);
}

class RequestExtractorImp implements RequestExtractor {
  @override
  LoginModel getAuthorizationBasic(Request request) {
    var authorization = request.headers['authorization'] ?? '';
    authorization = authorization.split(' ').last;
    authorization = String.fromCharCodes(base64Decode(authorization));
    final credential = authorization.split(':'); //email:pass
    return LoginModel(email: credential.first, password: credential.last);
  }

  @override
  String getAuthorizationBearer(Request request) {
    var authorization = request.headers['authorization'] ?? '';
    authorization = authorization.split(' ').last;
    return authorization;
  }
}
