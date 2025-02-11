import 'package:flutter/material.dart';
import 'package:lista_ir_agora/layout/layout.dart';

import 'filters_constant.dart';

class HeaderFilter extends SliverPersistentHeaderDelegate {
  const HeaderFilter();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final colors = AppColors.of(context);
    final spacing = AppSpacing.of(context);
    return Container(
        decoration: BoxDecoration(
            color: colors.scaffoldBackground,
            border: Border(bottom: BorderSide(color: colors.borderColor))),
        alignment: Alignment.center,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
              horizontal: spacing.marginApp, vertical: spacing.spacingXS),
          itemCount: FiltersConstant.filters.length + 1,
          separatorBuilder: (context, index) => SizedBox(
            width: spacing.spacingXS,
          ),
          itemBuilder: (context, index) {
            if (index == 0) {
              return ChoiceChip(
                label: Text(
                  FiltersConstant.filterButton,
                ),
                avatar: Icon(Icons.tune),
                onSelected: (value) {},
                selected: false,
              );
            }
            return ChoiceChip(
              label: Text(
                FiltersConstant.filters[index - 1],
              ),
              onSelected: (value) {},
              selected: false,
            );
          },
        ));
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant HeaderFilter oldDelegate) => false;
}
