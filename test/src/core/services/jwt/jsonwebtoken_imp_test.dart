import 'package:back_store/src/core/services/dot_env/dot_env_service.dart';
import 'package:back_store/src/core/services/jwt/jsonwebtoken_imp.dart';

import 'package:test/test.dart';

void main() {
  final service = DotEnvService(mocks: {
    'JWT_KEY': 'qweeeeeeeeeeeeesdadsad2312312312312',
  });

  test('jsonwebtoken DotEnvService ...', () async {
    expect(service['JWT_KEY'], 'qweeeeeeeeeeeeesdadsad2312312312312');
  });
  test('jsonwebtoken create', () async {
    final jwt = JsonwebtokenService(service);
    final expiresDate = DateTime.now().add(Duration(seconds: 30));
    final expiresIn =
        Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;

    final token = jwt.generateToken({"id": 0, "exp": expiresIn}, 'accessToken');

    print(token);
  });
}
