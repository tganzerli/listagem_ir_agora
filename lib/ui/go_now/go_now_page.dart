import 'package:flutter/material.dart';
import 'package:lista_ir_agora/core/config/injector.dart';

import 'viewmodels/go_now_state_viewmodels.dart';
import 'viewmodels/go_now_viewmodels.dart';

class GoNowPage extends StatefulWidget {
  const GoNowPage({super.key});

  @override
  State<GoNowPage> createState() => _GoNowPageState();
}

class _GoNowPageState extends State<GoNowPage> {
  final viewMode = injector.get<GoNowViewModel>();

  void listener() {
    GoNowStateViewmodels state = viewMode.state;
    if (state is GoNowError) {
      print(state.message);
    }
    if (state is GoNowSuccess) {
      print(state.motels.map((motel) => motel.toMap()).toList());
    }
  }

  @override
  void initState() {
    super.initState();
    viewMode.addListener(listener);
    viewMode.initEvent.execute();
  }

  @override
  void dispose() {
    super.dispose();
    viewMode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
