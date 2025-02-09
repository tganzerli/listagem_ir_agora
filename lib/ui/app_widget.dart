import 'package:flutter/material.dart';

import 'go_now/go_now_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const GoNowPage(),
      },
    );
  }
}
