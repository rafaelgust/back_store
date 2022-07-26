import 'package:shelf_modular/shelf_modular.dart';

import 'services/dot_env/dot_env_service.dart';

import 'services/database/database_service.dart';
import 'services/database/postgresql_imp.dart';

import 'services/encrypt/encrypt_service.dart';
import 'services/encrypt/bcrypt_imp.dart';

class CoreModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.instance<DotEnvService>(DotEnvService.instance, export: true),
        Bind.singleton<EncryptService>((i) => BCryptService(), export: true),
        Bind.singleton<RemoteDatabase>((i) => PostgresqlDatabase(i()),
            export: true),
      ];
}
