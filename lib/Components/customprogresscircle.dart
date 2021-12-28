import 'dart:math';

import 'package:flutter/material.dart';

class ProgressPainter extends CustomPainter {
  Color defaultCircleColor;
  Color percentageCompletedCircleColor;
  double completePercentage = 0.0;
  double circleWidth;

  ProgressPainter(this.defaultCircleColor, this.percentageCompletedCircleColor,
      this.completePercentage, this.circleWidth);

  @override
  void paint(Canvas canvas, Size size) {
    Paint defaultCirclePaint = getPaint(defaultCircleColor);
    Paint progressCirclePaint = getPaint(percentageCompletedCircleColor);

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, defaultCirclePaint);
    double arcAngle = 2 * pi * (completePercentage / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, progressCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Paint getPaint(Color defaultCircleColor) {
    return Paint()
      ..color = defaultCircleColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth;
  }
}
