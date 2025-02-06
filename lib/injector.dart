import 'package:auto_injector/auto_injector.dart';

final injector = AutoInjector(on: (i) {
  i.commit();
});
