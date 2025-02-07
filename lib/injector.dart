import 'package:auto_injector/auto_injector.dart';

import 'core/core.dart';

final injector = AutoInjector();

void setupDependencies() {
  injector.addInjector(core);
  injector.commit();
}
