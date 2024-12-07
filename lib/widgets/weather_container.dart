import 'package:flutter/material.dart';

class WeatherContainer extends StatelessWidget {
  final double x, y, width;
  final Color color;
  final BoxShape shape;

  const WeatherContainer({
    super.key,
    required this.x,
    required this.y,
    required this.width,
    required this.color,
    required this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(x, y),
      child: Container(
        height: 300,
        width: width,
        decoration: BoxDecoration(
          color: color,
          shape: shape,
        ),
      ),
    );
  }
}