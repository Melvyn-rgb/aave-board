import 'package:flutter/material.dart';

class ToggleSwitch extends StatelessWidget {
  final bool showDailyRevenue;
  final VoidCallback onToggle;

  const ToggleSwitch({
    super.key,
    required this.showDailyRevenue,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Show daily revenue',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 22,
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: showDailyRevenue ? Colors.purpleAccent : Colors.grey,
            ),
            child: Stack(
              alignment: showDailyRevenue
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
