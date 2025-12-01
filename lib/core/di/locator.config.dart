// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasource/auth_api_service.dart' as _i372;
import '../../features/auth/data/repository/auth_repository_impl.dart' as _i409;
import '../../features/auth/domain/repository/auth_repository.dart' as _i961;
import '../../features/auth/domain/usecase/auth_usecase.dart' as _i676;
import '../../features/auth/presentation/store/auth_store.dart' as _i172;
import '../../features/auth/presentation/store/login_store.dart' as _i847;
import '../../features/auth/presentation/store/verification_store.dart'
    as _i295;
import '../../features/chat/data/repository/chat_repository_impl.dart' as _i88;
import '../../features/chat/domain/repository/chat_repository.dart' as _i477;
import '../../features/chat/domain/usecase/chat_usecase.dart' as _i291;
import '../../features/chat/presentation/store/chat_store.dart' as _i448;
import '../../features/chat/presentation/store/message_store.dart' as _i575;
import '../../features/profile/presentation/store/profile_store.dart' as _i390;
import '../../features/user/data/datasource/user_api_service.dart' as _i673;
import '../../features/user/data/repository/user_repository_impl.dart' as _i733;
import '../../features/user/domain/repository/user_repository.dart' as _i450;
import '../../features/user/domain/usecase/user_usecase.dart' as _i281;
import '../../features/user/presentation/store/user_store.dart' as _i222;
import '../api/api_provider.dart' as _i1059;
import '../api/api_service.dart' as _i299;
import '../api/mock_api_service.dart' as _i631;
import '../services/storage/shared_storage.dart' as _i856;
import '../services/storage/storage.dart' as _i465;
import 'module.dart' as _i946;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.prefs,
    preResolve: true,
  );
  gh.singleton<_i558.FlutterSecureStorage>(() => registerModule.secureStorage);
  gh.singleton<_i361.Dio>(() => registerModule.dio);
  gh.lazySingleton<_i465.Storage>(
    () => _i856.SharedStorage(gh<_i460.SharedPreferences>()),
  );
  gh.singleton<_i299.ApiService>(() => _i631.MockApiService());
  gh.singleton<_i1059.ApiProvider>(() => _i1059.ApiProvider(gh<_i361.Dio>()));
  gh.lazySingleton<_i372.AuthApiService>(
    () => _i372.AuthApiService(gh<_i1059.ApiProvider>()),
  );
  gh.lazySingleton<_i673.UserApiService>(
    () => _i673.UserApiService(gh<_i1059.ApiProvider>()),
  );
  gh.lazySingleton<_i961.AuthRepository>(
    () => _i409.AuthRepositoryImpl(gh<_i372.AuthApiService>()),
  );
  gh.lazySingleton<_i676.AuthUseCase>(
    () => _i676.AuthUseCase(gh<_i961.AuthRepository>()),
  );
  gh.lazySingleton<_i477.ChatRepository>(
    () => _i88.ChatRepositoryImpl(gh<_i299.ApiService>()),
  );
  gh.lazySingleton<_i450.UserRepository>(
    () => _i733.UserRepositoryImpl(
      gh<_i299.ApiService>(),
      gh<_i673.UserApiService>(),
    ),
  );
  gh.lazySingleton<_i172.AuthStore>(
    () => _i172.AuthStore(gh<_i676.AuthUseCase>()),
  );
  gh.lazySingleton<_i847.LoginStore>(
    () => _i847.LoginStore(gh<_i676.AuthUseCase>()),
  );
  gh.lazySingleton<_i295.VerificationStore>(
    () => _i295.VerificationStore(gh<_i676.AuthUseCase>()),
  );
  gh.lazySingleton<_i390.ProfileStore>(
    () => _i390.ProfileStore(gh<_i676.AuthUseCase>()),
  );
  gh.lazySingleton<_i281.UserUseCase>(
    () => _i281.UserUseCase(gh<_i450.UserRepository>()),
  );
  gh.lazySingleton<_i222.UserStore>(
    () => _i222.UserStore(gh<_i281.UserUseCase>()),
  );
  gh.lazySingleton<_i291.ChatUseCase>(
    () => _i291.ChatUseCase(gh<_i477.ChatRepository>()),
  );
  gh.lazySingleton<_i448.ChatStore>(
    () => _i448.ChatStore(gh<_i291.ChatUseCase>()),
  );
  gh.factory<_i575.MessageStore>(
    () => _i575.MessageStore(gh<_i291.ChatUseCase>()),
  );
  return getIt;
}

class _$RegisterModule extends _i946.RegisterModule {}
