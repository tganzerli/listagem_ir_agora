import 'package:flutter/material.dart';
import 'package:lista_ir_agora/layout/layout.dart';

import 'pages/go_now/go_now_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(context),
      routes: {
        '/': (context) => const GoNowPage(),
      },
    );
  }
}
