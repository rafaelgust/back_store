import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../core/core_module.dart';

import 'swagger/swagger_handle.dart';

import 'users/users/users_resource.dart';

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
        Route.resource(UsersResource()),
        Route.resource(ProductsResource()),
      ];
}
