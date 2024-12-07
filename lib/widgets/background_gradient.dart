import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/widgets/weather_container.dart';

class BackgroundGradient extends StatelessWidget {
  final Widget child;

  const BackgroundGradient({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            const WeatherContainer(
              x: 3,
              y: -0.3,
              width: 300,
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
            const WeatherContainer(
              x: -3,
              y: -0.3,
              width: 300,
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
            const WeatherContainer(
              x: 0,
              y: -1.2,
              width: 600,
              color: Color(0XFFFFAB40),
              shape: BoxShape.rectangle,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 100,
                sigmaY: 100,
              ),
              child: Container(),
            ),
            child,
          ],
        ),
      ),
    );
  }
}