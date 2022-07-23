import 'package:shelf_modular/shelf_modular.dart';

import 'services/database/database_service.dart';
import 'services/database/postgresql_imp.dart';
import 'services/dot_env/dot_env_service.dart';

class CoreModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.instance<DotEnvService>(
          DotEnvService.instance,
          export: true,
        ),
        Bind.singleton<RemoteDatabase>(
          (i) => PostgresqlDatabase(i()),
          export: true,
        ),
      ];
}
