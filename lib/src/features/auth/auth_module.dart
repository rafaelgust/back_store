import 'package:shelf_modular/shelf_modular.dart';

import 'repositories/auth_repository.dart';
import 'datasource/auth_datasource.dart';

import 'resources/auth_resource.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<AuthDatasource>(
          (i) => AuthDatasourcePostgreSQL(i()),
        ),
        Bind.singleton<AuthRepository>(
          (i) => AuthRepositoryImp(i(), i(), i()),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(AuthResource()),
      ];
}
