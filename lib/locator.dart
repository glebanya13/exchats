import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/api/api_provider.dart';
import 'data/api/api_service.dart';
import 'data/api/mock_api_service.dart';
import 'data/repository/auth_repository_impl.dart';
import 'data/repository/user_repository_impl.dart';
import 'data/repository/chat_repository_impl.dart';
import 'domain/repository/auth_repository.dart';
import 'domain/repository/user_repository.dart';
import 'domain/repository/chat_repository.dart';
import 'domain/usecase/auth_usecase.dart';
import 'domain/usecase/user_usecase.dart';
import 'domain/usecase/chat_usecase.dart';
import 'presentation/store/auth_store.dart';
import 'presentation/store/user_store.dart';
import 'presentation/store/chat_store.dart';
import 'presentation/store/message_store.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPreferences);

  const baseUrl = 'https://api.example.com';
  locator.registerSingleton<ApiProvider>(
    ApiProvider(baseUrl: baseUrl),
  );
  locator.registerSingleton<ApiService>(
    MockApiService(locator<ApiProvider>()),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      locator<ApiService>(),
      locator<SharedPreferences>(),
    ),
  );
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(locator<ApiService>()),
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
