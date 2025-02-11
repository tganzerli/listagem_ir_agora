import 'package:flutter/material.dart';
import 'package:lista_ir_agora/core/config/injector.dart';
import 'package:lista_ir_agora/domain/entities/motels_entity.dart';
import 'package:lista_ir_agora/layout/layout.dart';

import 'viewmodels/featured_motels_viewmodels.dart';

class FeaturedMotels extends StatefulWidget {
  const FeaturedMotels({super.key});

  @override
  State<FeaturedMotels> createState() => _FeaturedMotelsState();
}

class _FeaturedMotelsState extends State<FeaturedMotels> {
  final viewModel = injector.get<FeaturedMotelsViewmodels>();

  final PageController _pageController = PageController();
  int _currentIndex = 0;

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
    return ValueListenableBuilder(
        valueListenable: viewModel,
        builder: (context, state, _) {
          return Container(
            width: size.width,
            height: 200,
            alignment: Alignment.bottomLeft,
            color: colors.borderColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 160,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: state.motels.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return buildSliderItem(state.motels[index]);
                    },
                  ),
                ),
                SizedBox(height: spacing.spacingXS),
                buildIndicator(context, lengthList: state.motels.length),
              ],
            ),
          );
        });
  }

  Widget buildSliderItem(MotelsEntity motel) {
    final colors = AppColors.of(context);
    final spacing = AppSpacing.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.spacingXS),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(spacing.spacingXS),
          child: Row(
            spacing: spacing.spacingXS,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(spacing.spacingXS),
                child: Image.network(
                  motel.logo.value,
                  width: 160,
                  height: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      motel.name,
                      style:
                          text.labelMedium!.copyWith(color: colors.textPrimary),
                    ),
                    Text(
                      motel.neighborhood,
                      style: text.headlineSmall,
                    ),
                    SizedBox(
                      height: spacing.spacingXXS,
                    ),
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: colors.scaffoldBackground,
                          borderRadius:
                              BorderRadius.circular(spacing.spacingXXS)),
                      child: Column(
                        children: [
                          SizedBox(height: spacing.spacingXS),
                          Text(
                            '30% de desconto',
                            style: text.titleMedium!
                                .copyWith(color: colors.textPrimary),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: spacing.spacingSM),
                            child: Divider(),
                          ),
                          Text(
                            'a partir de R\$ 130,65',
                            style: text.titleSmall,
                          ),
                          SizedBox(height: spacing.spacingXS),
                          SizedBox(
                            height: 30,
                            width: double.maxFinite,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Row(
                                spacing: 2,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'reservar',
                                    style: text.labelMedium,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 10,
                                    color: colors.cardBackground,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(BuildContext context, {required int lengthList}) {
    final colors = AppColors.of(context);
    final spacing = AppSpacing.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(lengthList, (index) {
        final bool isCurrent = _currentIndex == index;
        final double size = isCurrent ? 8 : 6;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing.spacingXXS),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent ? colors.textPrimary : colors.iconColor,
          ),
        );
      }),
    );
  }
}
