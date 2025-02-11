import 'package:flutter/material.dart';
import 'package:lista_ir_agora/layout/layout.dart';

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({super.repaint, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashWidth = 4, dashSpace = 2, startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height),
          Offset(startX + dashWidth, size.height), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DottedLine extends StatelessWidget {
  final Widget child;
  final Color? color;
  const DottedLine({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, 1),
          foregroundPainter: DottedLinePainter(
              color: color ?? colors.cardBackground.withValues(alpha: 0.6)),
          child: child,
        );
      },
    );
  }
}
