import 'package:flutter/material.dart';
import 'package:lista_ir_agora/core/config/injector.dart';
import 'package:lista_ir_agora/layout/layout.dart';

import '../../widgets/appbar/appbar_widget.dart';
import 'go_now_body.dart';
import 'viewmodels/go_now_viewmodels.dart';

class GoNowPage extends StatefulWidget {
  const GoNowPage({super.key});

  @override
  State<GoNowPage> createState() => _GoNowPageState();
}

class _GoNowPageState extends State<GoNowPage> {
  final viewModel = injector.get<GoNowViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.initEvent.execute();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final size = MediaQuery.of(context).size;
    final spacing = AppSpacing.of(context);
    return Scaffold(
      backgroundColor: colors.primaryRed,
      appBar: AppbarWidget(
        filterLable: 'Zona Sul',
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: colors.scaffoldBackground,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(spacing.marginApp)),
        ),
        clipBehavior: Clip.hardEdge,
        child: GoNowBody(
          viewModel: viewModel,
        ),
      ),
    );
  }
}
