import 'package:universal_html/html.dart' show window, Storage;

class StorageProvider {
  final Storage _localStorage = window.localStorage;
  
  String? read({required String key}) {
    return _localStorage.containsKey(key) ? _localStorage[key]! : null;
  }

  void write({required String key, required String value}) {
    _localStorage[key] = value;
  }

  void delete({required String key}) {
    _localStorage.remove(key);
  }
}