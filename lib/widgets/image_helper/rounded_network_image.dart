import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class RoundedNetworkImage extends StatelessWidget {
  final double imageSize;
  final String imageUrl;
  final double strokeWidth;
  final Color strokeColor;

  RoundedNetworkImage({
    @required this.imageSize,
    @required this.imageUrl,
    this.strokeWidth,
    this.strokeColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RoundedNetworkImageBorder(
        strokeWidth: strokeWidth,
        strokeColor: strokeColor,
      ),
      child: Container(
        width: imageSize,
        height: imageSize,
        child: ClipOval(
          child: CachedNetworkImage(
            progressIndicatorBuilder: (ctx, url, downloadProgress) => Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
              ),
            ),
            imageUrl: imageUrl != null ? imageUrl : '',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class RoundedNetworkImageBorder extends CustomPainter {
  final double strokeWidth;
  final Color strokeColor;

  RoundedNetworkImageBorder({this.strokeWidth, this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);

    Paint borderPaint = Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    borderPaint.color = strokeColor;

    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90), math.radians(360), false, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
