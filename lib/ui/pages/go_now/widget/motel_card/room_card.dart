import 'package:flutter/material.dart';
import 'package:lista_ir_agora/core/core.dart';
import 'package:lista_ir_agora/domain/dto/room_periods_dto.dart';
import 'package:lista_ir_agora/domain/entities/rooms_entity.dart';
import 'package:lista_ir_agora/layout/layout.dart';

class RoomCard extends StatelessWidget {
  final RoomsEntity room;
  final double width;
  const RoomCard({
    super.key,
    required this.room,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  _header(context),
                  _categoryItems(context),
                  Column(
                    children: List.generate(
                        room.periods.length,
                        (index) =>
                            _periods(context, period: room.periods[index])),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    final spacing = AppSpacing.of(context);
    final text = Theme.of(context).textTheme;
    return Card(
        child: SizedBox(
      width: width,
      height: 270,
      child: Padding(
        padding: EdgeInsets.all(spacing.spacingXS),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(spacing.spacingXS),
              child: Image.network(
                room.imagens.first.value,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(room.name,
                    style: text.headlineLarge,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade)
              ],
            )),
          ],
        ),
      ),
    ));
  }

  Widget _categoryItems(BuildContext context) {
    final colors = AppColors.of(context);
    final spacing = AppSpacing.of(context);
    final text = Theme.of(context).textTheme;
    Widget box(UrlImagemVo icon) {
      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
            color: colors.scaffoldBackground,
            borderRadius: BorderRadius.circular(spacing.spacingXS)),
        child: Image.network(
          icon.value,
          fit: BoxFit.cover,
        ),
      );
    }

    return Card(
        child: SizedBox(
      width: width,
      height: 60,
      child: Padding(
        padding: EdgeInsets.all(spacing.spacingXS),
        child: Row(
          spacing: spacing.spacingXS,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              spacing: spacing.spacingXS,
              children: List.generate(
                  room.categoryItems.length > 3 ? 3 : room.categoryItems.length,
                  (index) => box(room.categoryItems[index].icon)),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                color: Colors.transparent,
                child: Row(
                  spacing: spacing.spacingXS,
                  children: [
                    SizedBox(
                        width: 36,
                        child: Text(
                          'ver todos',
                          style: text.labelSmall!
                              .copyWith(color: colors.textSecondary),
                          textAlign: TextAlign.right,
                        )),
                    Icon(
                      Icons.expand_more,
                      size: 14,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget _periods(BuildContext context, {required RoomPeriodsDto period}) {
    final spacing = AppSpacing.of(context);
    final text = Theme.of(context).textTheme;
    return Card(
        child: SizedBox(
      width: width,
      height: 80,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.spacingLG),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: spacing.spacingXXS,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  period.formattedTime,
                  style: text.headlineLarge,
                ),
                Text(
                  'R\$ ${period.amount.toFormattedString()}',
                  style: text.headlineLarge,
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ],
        ),
      ),
    ));
  }
}
