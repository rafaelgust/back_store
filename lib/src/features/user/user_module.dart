import 'package:shelf_modular/shelf_modular.dart';

import 'datasource/user_datasource.dart';
import 'repositories/user_repository.dart';

import 'resources/user_resource.dart';

class UserModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<UserDatasource>((i) => UserDatasourcePostgreSQL(i())),
        Bind.singleton<UserRepository>((i) => UserRepositoryImp(i(), i())),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(UserResource()),
      ];
}
