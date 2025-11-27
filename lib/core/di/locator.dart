import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_provider.dart';
import '../api/api_service.dart';
import '../api/mock_api_service.dart';
import '../../features/auth/data/datasource/auth_api_service.dart';
import '../../features/user/data/datasource/user_api_service.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/user/data/repository/user_repository_impl.dart';
import '../../features/chat/data/repository/chat_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/user/domain/repository/user_repository.dart';
import '../../features/chat/domain/repository/chat_repository.dart';
import '../../features/auth/domain/usecase/auth_usecase.dart';
import '../../features/user/domain/usecase/user_usecase.dart';
import '../../features/chat/domain/usecase/chat_usecase.dart';
import '../../features/auth/presentation/store/auth_store.dart';
import '../../features/user/presentation/store/user_store.dart';
import '../../features/chat/presentation/store/chat_store.dart';
import '../../features/chat/presentation/store/message_store.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPreferences);

  const baseUrl = 'https://exchats.com';
  locator.registerSingleton<ApiProvider>(
    ApiProvider(baseUrl: baseUrl),
  );
  locator.registerSingleton<ApiService>(
    MockApiService(),
  );
  locator.registerLazySingleton<AuthApiService>(
    () => AuthApiService(locator<ApiProvider>()),
  );
  locator.registerLazySingleton<UserApiService>(
    () => UserApiService(locator<ApiProvider>()),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      locator<AuthApiService>(),
      locator<ApiProvider>(),
      locator<SharedPreferences>(),
    ),
  );
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      locator<ApiService>(),
      locator<UserApiService>(),
    ),
  );
  locator.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(locator<ApiService>()),
  );

  locator.registerLazySingleton<AuthUseCase>(
    () => AuthUseCase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<UserUseCase>(
    () => UserUseCase(locator<UserRepository>()),
  );
  locator.registerLazySingleton<ChatUseCase>(
    () => ChatUseCase(locator<ChatRepository>()),
  );

  locator.registerLazySingleton<AuthStore>(
    () => AuthStore(locator<AuthUseCase>()),
  );
  locator.registerLazySingleton<UserStore>(
    () => UserStore(locator<UserUseCase>()),
  );
  locator.registerLazySingleton<ChatStore>(
    () => ChatStore(locator<ChatUseCase>()),
  );

  locator.registerFactory<MessageStore>(
    () => MessageStore(locator<ChatUseCase>()),
  );
}
