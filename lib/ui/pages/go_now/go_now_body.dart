import 'package:flutter/material.dart';
import 'package:lista_ir_agora/layout/layout.dart';
import 'viewmodels/go_now_state_viewmodels.dart';
import 'widget/featured_motels/featured_motels.dart';
import 'viewmodels/go_now_viewmodels.dart';
import 'widget/header_filter/header_filter.dart';
import 'widget/motel_card/motel_card.dart';

class GoNowBody extends StatelessWidget {
  final GoNowViewModel viewModel;
  const GoNowBody({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final spacing = AppSpacing.of(context);
    return ValueListenableBuilder(
      valueListenable: viewModel,
      builder: (context, state, _) {
        if (state is GoNowLoading) {
          return Container();
        }
        if (state.motels.isEmpty) {
          return Container();
        }
        return SafeArea(
          child: Scaffold(
            body: NestedScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: FeaturedMotels(),
                  ),
                  SliverPersistentHeader(
                    delegate: HeaderFilter(),
                    pinned: true,
                  ),
                ];
              },
              body: ListView.separated(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: state.motels.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: spacing.marginApp,
                ),
                itemBuilder: (context, index) {
                  return MotelCard(motel: state.motels[index]);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
