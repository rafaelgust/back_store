import 'package:back_store/src/core/services/dot_env/dot_env_service.dart';
import 'package:test/test.dart';

void main() {
  test('dot env service ...', () async {
    final service = DotEnvService.instance;
    expect(
        service['DATABASE_URL'], 'postgres://postgres:password@localhost:5432');
  });
}
