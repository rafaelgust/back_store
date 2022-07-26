import 'package:back_store/src/core/models/login_model.dart';
import 'package:back_store/src/core/services/encrypt/encrypt_service.dart';
import 'package:back_store/src/core/services/jwt/jwt_service.dart';

import '../datasource/auth_datasource.dart';
import '../exceptions/auth_exceptions.dart';
import '../models/tokenization_model.dart';

abstract class AuthRepository {
  final AuthDatasource datasource;

  final EncryptService encrypt;
  final JwtService jwt;

  AuthRepository(this.encrypt, this.jwt, this.datasource);

  Future<TokenizationModel> login(LoginModel credentials);
}

class AuthRepositoryImp implements AuthRepository {
  @override
  final AuthDatasource datasource;
  @override
  final EncryptService encrypt;
  @override
  final JwtService jwt;

  AuthRepositoryImp(this.encrypt, this.jwt, this.datasource);

  @override
  Future<TokenizationModel> login(LoginModel credentials) async {
    final user = await datasource.getIdByEmail(credentials.email);

    if (!encrypt.checkHash(credentials.password, user['password'])) {
      throw AuthExceptions(403, 'email or password invalid');
    }

    final payload = user..remove('password');

    return _generateToken(payload);
  }

  TokenizationModel _generateToken(Map payload) {
    payload['exp'] = _expiration(Duration(minutes: 5));
    final accessToken = jwt.generateToken(payload, 'accessToken');
    payload['exp'] = _expiration(Duration(days: 3));
    final refreshToken = jwt.generateToken(payload, 'refreshToken');

    return TokenizationModel(
        accessToken: accessToken, refreshToken: refreshToken);
  }

  int _expiration(Duration duration) {
    final expiresDate = DateTime.now().add(Duration(seconds: 30));
    return Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;
  }
}
