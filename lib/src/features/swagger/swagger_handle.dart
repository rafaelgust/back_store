import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

FutureOr<Response> swaggerHandle(Request request) async {
  final path = 'specs/swagger.yaml';
  final handler = SwaggerUI(
    title: 'Documentation Store API',
    deepLink: true,
    path,
  );
  return handler(request);
}
