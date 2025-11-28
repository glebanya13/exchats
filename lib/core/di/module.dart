import 'package:dio/dio.dart';
import 'package:exchats/core/api/api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        iOptions: IOSOptions(
          accountName: 'com.exchats.app',
        ),
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  Dio get dio => Api.createDio();
}
