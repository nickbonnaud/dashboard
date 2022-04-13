import 'package:universal_html/html.dart' show window;

class StorageProvider {

  const StorageProvider();
  
  String? read({required String key}) {
    return window.localStorage.containsKey(key) ? window.localStorage[key]! : null;
  }

  void write({required String key, required String value}) {
    window.localStorage[key] = value;
  }

  void delete({required String key}) {
    window.localStorage.remove(key);
  }
}