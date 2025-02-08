import 'package:auto_injector/auto_injector.dart';

import 'core/core.dart';
import 'data/data.dart';

final injector = AutoInjector();

void setupDependencies() {
  injector.addInjector(core);
  injector.addInjector(data);
  injector.commit();
}
