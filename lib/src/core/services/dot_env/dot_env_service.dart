import 'dart:io';

class DotEnvService {
  DotEnvService._() {
    _init();
  }
  static DotEnvService instance = DotEnvService._();

  final Map<String, String> _map = {};

  void _init() {
    final file = File('.env');
    final envText = file.readAsStringSync();

    for (var line in envText.split('\n')) {
      final lineBreak = line.split('=');
      _map[lineBreak[0]] = lineBreak[1];
    }
  }

  String? operator [](String key) {
    return _map[key];
  }
}
