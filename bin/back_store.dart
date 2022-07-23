import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_modular/shelf_modular.dart';

import 'package:back_store/src/features/app_module.dart';

void main(List<String> arguments) async {
  final modularHandler = Modular(
    module: AppModule(),
    middlewares: [logRequests()],
  );

  final server = await io.serve(modularHandler, '0.0.0.0', 3000);
  print('Server started: ${server.address.address}:${server.port}');
}
