class NetworkData {
  final String network;
  final String networkImage;
  final List<AssetData> assets;

  NetworkData({
    required this.network,
    required this.networkImage,
    required this.assets,
  });

  factory NetworkData.fromJson(Map<String, dynamic> json) {
    return NetworkData(
      network: json['network'],
      networkImage: json['networkImage'],
      assets: (json['assets'] as List)
          .map((assetJson) => AssetData.fromJson(assetJson))
          .toList(),
    );
  }

  double calculateDailyRevenue() {
    return assets.fold(0.0, (sum, asset) => sum + asset.calculateDailyRevenue());
  }

  double calculateTotalBalance() {
    return assets.fold(0.0, (sum, asset) => sum + asset.balanceInUSD);
  }
}

class AssetData {
  final String symbol;
  final String underlyingAsset;
  final String imageUrl;
  final double tokenBalance;
  final double balanceInUSD;
  final double liquidityRate;

  AssetData({
    required this.symbol,
    required this.underlyingAsset,
    required this.imageUrl,
    required this.tokenBalance,
    required this.balanceInUSD,
    required this.liquidityRate,
  });

  factory AssetData.fromJson(Map<String, dynamic> json) {
    return AssetData(
      symbol: json['symbol'],
      underlyingAsset: json['underlyingAsset'],
      imageUrl: json['image_url'],
      tokenBalance: json['tokenBalance'].toDouble(),
      balanceInUSD: json['balanceInUSD'].toDouble(),
      liquidityRate: json['liquidityRate'].toDouble(),
    );
  }

  double calculateDailyRevenue() {
    return (balanceInUSD * liquidityRate / 100) / 365;
  }
}