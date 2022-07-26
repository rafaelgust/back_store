import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../dot_env/dot_env_service.dart';

import 'jwt_service.dart';

class JsonwebtokenService implements JwtService {
  final DotEnvService dotEnvService;

  JsonwebtokenService(this.dotEnvService);
  @override
  String generateToken(Map claims, String audience) {
    final jwt = JWT(claims, audience: Audience.one(audience));
    return jwt.sign(SecretKey(dotEnvService['JWT_KEY']!));
  }

  @override
  void verifyToken(String token, String audience) {
    try {
      JWT.verify(
        token,
        SecretKey(dotEnvService['JWT_KEY']!),
        audience: Audience.one(audience),
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Map getPayload(String token) {
    final jwt = JWT.verify(
      token,
      SecretKey(dotEnvService['JWT_KEY']!),
      checkNotBefore: false,
      checkHeaderType: false,
      checkExpiresIn: false,
    );
    return jwt.payload;
  }
}
