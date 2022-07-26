abstract class EncryptService {
  String generateHash(String text);
  bool checkHash(String text, String hash);
}
