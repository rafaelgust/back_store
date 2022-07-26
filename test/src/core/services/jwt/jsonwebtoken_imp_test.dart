import 'package:back_store/src/core/services/dot_env/dot_env_service.dart';
import 'package:back_store/src/core/services/jwt/jsonwebtoken_imp.dart';

import 'package:test/test.dart';

void main() {
  final service =
      DotEnvService(mocks: {'JWT_KEY': 'qweeeeeeeeeeeeesdadsad2312312312312'});

  test('jsonwebtoken DotEnvService ...', () async {
    expect(service['JWT_KEY'], 'qweeeeeeeeeeeeesdadsad2312312312312');
  });

  test('jsonwebtoken create', () async {
    final jwt = JsonwebtokenService(service);
    final expiresDate = DateTime.now().add(Duration(seconds: 30));
    final expiresIn =
        Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;
    final token = jwt.generateToken({"id": 0, "exp": expiresIn}, 'accessToken');

    expect(
      token,
      isA<String>(),
    );
  });

  test('jsonwebtoken verify', () async {
    final jwt = JsonwebtokenService(service);
    final expiresDate = DateTime.now().add(Duration(seconds: 30));
    final expiresIn =
        Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;

    final token = jwt.generateToken({"id": 0, "exp": expiresIn}, 'accessToken');

    expect(
      () => jwt.verifyToken(token, 'accessToken'),
      isA<void>(),
    );
  });

  test('jsonwebtoken verify error token duration', () async {
    final jwt = JsonwebtokenService(service);
    final expiresDate = DateTime.now().add(Duration(seconds: 1));
    final expiresIn =
        Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;

    final token = jwt.generateToken({"id": 0, "exp": expiresIn}, 'accessToken');
    jwt.verifyToken(token, 'accessToken');

    await Future.delayed(Duration(seconds: 5));

    expect(
      () => jwt.verifyToken(token, 'accessToken'),
      throwsA(
        isA<Exception>(),
      ),
    );
  });

  test('jsonwebtoken verify error type audience', () async {
    final jwt = JsonwebtokenService(service);
    final expiresDate = DateTime.now().add(Duration(seconds: 30));
    final expiresIn =
        Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;

    final token = jwt.generateToken({"id": 0, "exp": expiresIn}, 'accessToken');
    expect(
      () => jwt.verifyToken(token, 'refreshToken'),
      throwsA(
        isA<Exception>(),
      ),
    );
  });

  test('jsonwebtoken payload', () async {
    final jwt = JsonwebtokenService(service);

    final payload = jwt.getPayload(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MCwiZXhwIjoxNjU4ODAzOTU0LCJpYXQiOjE2NTg4MDM5MjQsImF1ZCI6ImFjY2Vzc1Rva2VuIn0.EpY2oibMUVbKMZQsghSAiWThSjjokT14g71TVgIoKM8');

    Map test = {'id': 0, 'exp': 1658803954, 'iat': 1658803924};
    expect(payload, test);
  });
}
