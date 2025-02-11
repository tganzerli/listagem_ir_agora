import 'package:flutter/material.dart';
import 'package:lista_ir_agora/layout/layout.dart';

import 'toggle.dart';

class AppbarWidget extends StatefulWidget implements PreferredSizeWidget {
  final void Function()? leading;
  final void Function()? search;
  final void Function(bool firstIsSelected)? onToggle;
  final void Function()? onLocation;
  final String filterLable;
  const AppbarWidget(
      {super.key,
      this.leading,
      this.search,
      this.onToggle,
      required this.filterLable,
      this.onLocation});

  @override
  State<AppbarWidget> createState() => _AppbarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(100);
}

class _AppbarWidgetState extends State<AppbarWidget> {
  bool firstIsSelected = true;
  void onToggle() {
    if (widget.onToggle != null) {
      setState(() {
        firstIsSelected = !firstIsSelected;
      });
      widget.onToggle!(firstIsSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colos = AppColors.of(context);
    final spacing = AppSpacing.of(context);
    final text = Theme.of(context).textTheme;
    return AppBar(
      leading: GestureDetector(onTap: widget.leading, child: Icon(Icons.menu)),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
              onTap: widget.search, child: Icon(Icons.search_rounded)),
        )
      ],
      title: ToggleButton(
        firstIsSelected: firstIsSelected,
        onToggle: onToggle,
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: spacing.spacingSM),
            child: DottedLine(
              child: GestureDetector(
                onTap: widget.onLocation,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.filterLable,
                        style: text.labelMedium,
                      ),
                      Icon(
                        Icons.expand_more,
                        color: colos.cardBackground,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
