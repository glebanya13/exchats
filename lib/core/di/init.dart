import 'package:easy_localization/easy_localization.dart';
import 'package:exchats/env.dart';

import 'locator.dart';

Future<void> initDI() async {
  await EasyLocalization.ensureInitialized();

  await initLocator(Env.type);
}
