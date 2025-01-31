import 'dart:math';
import 'package:flutter/material.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final double dragOffset;
  final bool isRefreshing;
  final AnimationController animationController;

  const CustomRefreshIndicator({
    super.key,
    required this.dragOffset,
    required this.isRefreshing,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    if (dragOffset == 0 && !isRefreshing) return const SizedBox.shrink();

    return Container(
      height: isRefreshing ? 60 : dragOffset.clamp(0.0, 100.0),
      child: Center(
        child: isRefreshing
            ? _buildAnimatedRefreshIndicator()
            : _buildRotatingRefreshIcon(),
      ),
    );
  }

  Widget _buildAnimatedRefreshIndicator() {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Opacity(
          opacity: 0.5 + 0.1 * cos(animationController.value * 2 * pi),
          child: child,
        );
      },
      child: Image.network(
        'https://cryptologos.cc/logos/aave-aave-logo.png',
        height: 40,
        width: 40,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildRotatingRefreshIcon() {
    return Transform.rotate(
      angle: (dragOffset / 100) * 2 * pi,
      child: const Icon(
        Icons.refresh,
        size: 30,
        color: Colors.grey,
      ),
    );
  }
}