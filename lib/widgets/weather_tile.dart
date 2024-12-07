import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final dynamic subtitle;

  const WeatherTile({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Image.asset(
            imagePath,
            scale: 8,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                subtitle is String
                    ? subtitle
                    : DateFormat().add_jm().format(subtitle),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}