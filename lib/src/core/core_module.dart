import 'package:shelf_modular/shelf_modular.dart';

import 'services/dot_env/dot_env_service.dart';

import 'services/database/database_service.dart';
import 'services/database/postgresql_imp.dart';

import 'services/encrypt/encrypt_service.dart';
import 'services/encrypt/bcrypt_imp.dart';

import 'services/jwt/jwt_service.dart';
import 'services/jwt/jsonwebtoken_imp.dart';

import 'services/request_extractor/request_extractor_service.dart';

class CoreModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<DotEnvService>((i) => DotEnvService(), export: true),
        Bind.singleton<EncryptService>((i) => BCryptService(), export: true),
        Bind.singleton<RequestExtractor>(
          (i) => RequestExtractorImp(),
          export: true,
        ),
        Bind.singleton<JwtService>(
          (i) => JsonwebtokenService(i()),
          export: true,
        ),
        Bind.singleton<RemoteDatabase>(
          (i) => PostgresqlDatabase(i()),
          export: true,
        ),
      ];
}
