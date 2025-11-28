import 'package:exchats/core/services/storage/storage.dart';

enum StorageKeys {
  hasRunBefore,
  currentUserId,
}

class LocalUserStorage {
  static final _storage = Storage.instance;

  static bool get hasRunBefore {
    return _storage.get<bool>(StorageKeys.hasRunBefore.name) ?? false;
  }

  static set hasRunBefore(bool newValue) {
    _storage.put(StorageKeys.hasRunBefore.name, newValue);
  }

  static String? get currentUserId {
    return _storage.get<String>(StorageKeys.currentUserId.name);
  }

  static set currentUserId(String? newValue) {
    if (newValue == null) {
      _storage.delete(StorageKeys.currentUserId.name);
      return;
    }

    _storage.put(StorageKeys.currentUserId.name, newValue);
  }

  static void clearAll() {
    _storage.clear();
  }
}
