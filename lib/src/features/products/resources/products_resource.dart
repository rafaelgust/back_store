import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class ProductsResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/products', _getProducts),
        Route.get('/product/:id', _getProductById),
        Route.post('/product', _createProduct),
        Route.put('/product', _updateProduct),
        Route.delete('/product/:id', _deleteProduct),
      ];
}

FutureOr<Response> _getProducts() {
  return Response.ok('Products ok!');
}

FutureOr<Response> _getProductById(ModularArguments arguments) {
  return Response.ok('Product => ${arguments.params['id']} ok!');
}

FutureOr<Response> _createProduct(ModularArguments arguments) {
  return Response.ok('Product => Json to create ${arguments.data}');
}

FutureOr<Response> _updateProduct(ModularArguments arguments) {
  return Response.ok('Product => Json to update ${arguments.data}');
}

FutureOr<Response> _deleteProduct(ModularArguments arguments) {
  return Response.ok('Product Deleted => ${arguments.params['id']}');
}
