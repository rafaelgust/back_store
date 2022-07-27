import 'package:back_store/src/core/core_module.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'auth/auth_module.dart';
import 'user/user_module.dart';

import 'swagger/swagger_handle.dart';

import 'products/resources/products_resource.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('OK!')),
        Route.get('/documentation/**', swaggerHandle),
        Route.module('/auth', module: AuthModule()),
        Route.module('/user', module: UserModule()),
        Route.resource(ProductsResource()),
      ];
}
