import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class LiquidityDashboardApp extends StatelessWidget {
  const LiquidityDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquidity Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ).copyWith(
          primary: Colors.white, // Adjust if needed
          outline: Colors.white, // Removes blue outline
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}