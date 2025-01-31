import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final double value;
  final bool isPercentage;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            _buildValueText(),
          ],
        ),
      ),
    );
  }

  Widget _buildValueText() {
    if (isPercentage) {
      return Text(
        '${value.toStringAsFixed(2)}%',
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        '\$${value.toStringAsFixed(value < 1 ? 3 : 2)}',
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}