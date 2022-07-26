import 'package:bcrypt/bcrypt.dart';

import 'encrypt_service.dart';

class BCryptService implements EncryptService {
  @override
  String generateHash(String text) {
    return BCrypt.hashpw(text, BCrypt.gensalt());
  }

  @override
  bool checkHash(String text, String hash) {
    return BCrypt.checkpw(text, hash);
  }
}
