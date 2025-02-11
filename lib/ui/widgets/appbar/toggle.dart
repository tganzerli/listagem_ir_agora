import 'package:flutter/material.dart';
import 'package:lista_ir_agora/layout/themes/colors/app_colors.dart';
import 'package:lista_ir_agora/layout/themes/spacing/spacing.dart';

import 'appbar_constant.dart';

class ToggleButton extends StatelessWidget {
  final VoidCallback onToggle;
  final bool firstIsSelected;
  const ToggleButton({
    super.key,
    required this.onToggle,
    required this.firstIsSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colos = AppColors.of(context);
    final spacing = AppSpacing.of(context);
    return Container(
      height: spacing.spacingXL,
      decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(spacing.spacingXL)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedAlign(
                alignment: firstIsSelected
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth / 2,
                  decoration: BoxDecoration(
                      color: colos.cardBackground,
                      borderRadius: BorderRadius.circular(spacing.spacingXL)),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: _toggleItem(
                        context,
                        icon: Icons.flash_on,
                        label: AppbarConstant.toggle.firstButton,
                        isActive: firstIsSelected,
                      )),
                  Expanded(
                      flex: 1,
                      child: _toggleItem(
                        context,
                        icon: Icons.calendar_today,
                        label: AppbarConstant.toggle.secondButton,
                        isActive: !firstIsSelected,
                      )),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _toggleItem(BuildContext context,
      {required IconData icon, required String label, required bool isActive}) {
    final colors = AppColors.of(context);
    final spacing = AppSpacing.of(context);
    final text = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: isActive ? null : onToggle,
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: spacing.spacingXXS,
          children: [
            Icon(icon,
                size: spacing.spacingSM,
                color: isActive ? colors.primaryRed : colors.cardBackground),
            Text(
              label,
              style: isActive
                  ? text.labelMedium!.copyWith(color: colors.textPrimary)
                  : text.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
