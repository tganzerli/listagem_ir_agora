import 'package:auto_injector/auto_injector.dart';

import 'core/core.dart';

final injector = AutoInjector(on: (i) {
  i.addInjector(core);
  i.commit();
});
