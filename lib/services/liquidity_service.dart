import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/network_data.dart';

class LiquidityService {
  static const String _baseUrl = 'http://localhost:3000/api/liquidity-rates';

  Future<List<NetworkData>> fetchLiquidityRates() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => NetworkData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load liquidity rates');
      }
    } catch (e) {
      print('Error fetching liquidity rates: $e');
      rethrow;
    }
  }

  static double calculateTotalDailyRevenue(List<NetworkData> networkData) {
    return networkData.fold(0.0, (sum, network) => sum + network.calculateDailyRevenue());
  }

  static double calculateTotalBalance(List<NetworkData> networkData) {
    return networkData.fold(0.0, (sum, network) => sum + network.calculateTotalBalance());
  }

  static double calculateAverageAPY(List<NetworkData> networkData) {
    if (networkData.isEmpty) return 0.0;

    int totalAssets = networkData.fold(0, (sum, network) => sum + network.assets.length);
    double totalAPY = networkData.fold(0.0, (sum, network) {
      return sum + network.assets.fold(0.0, (assetSum, asset) => assetSum + asset.liquidityRate);
    });

    return totalAPY / totalAssets;
  }
}