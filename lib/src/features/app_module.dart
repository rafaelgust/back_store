import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.get('/', () => Response.ok('OK!')),
        Route.get('/auth', () => Response.ok('auth ok!')),
        Route.get('/products', () => Response.ok('products ok!')),
      ];
}
