import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage.dart';

@LazySingleton(as: Storage)
class SharedStorage implements Storage {
  final SharedPreferences _sharedPreferences;

  SharedStorage(this._sharedPreferences);

  final List<String> _supportedTypes = [
    'String',
    'bool',
    'int',
    'double',
    'DateTime',
    'List<String>',
  ];

  @override
  T? get<T>(String key, {T? def}) {
    final exist = _sharedPreferences.containsKey(key);
    final type = T.toString();

    checkType(type);
    if (!exist) {
      return def;
    }
    switch (type) {
      case 'String':
        return _sharedPreferences.getString(key) as T?;
      case 'DateTime':
        return DateTime.tryParse(_sharedPreferences.getString(key)!) as T?;
      case 'bool':
        return _sharedPreferences.getBool(key) as T?;
      case 'int':
        return _sharedPreferences.getInt(key) as T?;
      case 'double':
        return _sharedPreferences.getDouble(key) as T?;
      case 'List<String>':
        return _sharedPreferences.getStringList(key) as T?;
    }
    return null;
  }

  @override
  void put(String key, Object value) {
    final type = value.runtimeType.toString();

    checkType(type);

    switch (type) {
      case 'bool':
        _sharedPreferences.setBool(key, value as bool);
        break;
      case 'String':
        _sharedPreferences.setString(key, value as String);
        break;
      case 'int':
        _sharedPreferences.setInt(key, value as int);
        break;
      case 'double':
        _sharedPreferences.setDouble(key, value as double);
        break;
      case 'DateTime':
        _sharedPreferences.setString(key, value.toString());
        break;
      case 'List<String>':
        _sharedPreferences.setStringList(key, value as List<String>);
        break;
    }
  }

  @override
  void delete(String key) {
    _sharedPreferences.remove(key);
  }

  @override
  void deleteKeys(List<String> keys) {
    for (final key in keys) {
      _sharedPreferences.remove(key);
    }
  }

  @override
  void clear({List<String> keys = const []}) {
    _sharedPreferences.clear();
  }

  @override
  bool exists(String key) {
    return _sharedPreferences.containsKey(key);
  }

  void checkType(String type) {
    if (!_supportedTypes.contains(type)) {
      throw Exception('SharedStorage does not support this data type "$type"');
    }
  }
}
