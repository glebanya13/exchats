import 'package:exchats/env.dart';

import 'locator.dart';

Future<void> initDI() async {
  await initLocator(Env.type);
}
