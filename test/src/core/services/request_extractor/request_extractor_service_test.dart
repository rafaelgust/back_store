import 'package:back_store/src/core/models/login_model.dart';
import 'package:back_store/src/core/services/request_extractor/request_extractor_service.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final service = RequestExtractorImp();
  test('request extractor getAuthorizationBearer ', () async {
    var request = Request('GET', Uri.parse('http://localhost/'), headers: {
      'authorization': 'bearer dsadasdasdf4564564',
    });

    final token = service.getAuthorizationBearer(request);

    expect(token, 'dsadasdasdf4564564');
  });

  test('request extractor getAuthorizationBasic', () async {
    String encode = 'cmFmYWVsOnNlbmhh';
    LoginModel decode = LoginModel(email: 'rafael', password: 'senha');

    var request = Request('GET', Uri.parse('http://localhost/'), headers: {
      'authorization': 'basic $encode',
    });

    final token = service.getAuthorizationBasic(request);

    expect(token, TypeMatcher<LoginModel>());
    expect(token.email, decode.email);
    expect(token.password, decode.password);
  });
}
