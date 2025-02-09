import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_ir_agora/core/config/injector.dart';

import 'core/config/http_overrides.dart';
import 'ui/app_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  setupHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const AppWidget());
}
