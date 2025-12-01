import '../../di/locator.dart';

abstract class Storage {
  bool exists(String key);

  T? get<T>(String key, {T def});

  void put(String key, Object value);

  void delete(String key);

  void deleteKeys(List<String> keys);

  void clear();

  static Storage get instance => locator<Storage>();
}
