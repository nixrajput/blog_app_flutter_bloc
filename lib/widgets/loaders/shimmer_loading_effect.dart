import 'package:flutter/material.dart';

class ShimmerLoadingWidget extends StatefulWidget {
  final double height;
  final double width;
  final bool isCircle;

  ShimmerLoadingWidget({
    this.height = 20,
    this.width = 200,
    this.isCircle = false,
  });

  createState() => ShimmerLoadingWidgetState();
}

class ShimmerLoadingWidgetState extends State<ShimmerLoadingWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
        setState(() {});
      });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
          gradient: LinearGradient(
            begin: Alignment(gradientPosition.value, 0),
            end: Alignment(-1, 0),
            colors: [
              Colors.grey.shade500,
              Colors.grey.shade600,
              Colors.grey.shade500
            ],
          )),
    );
  }
}
