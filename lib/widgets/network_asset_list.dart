import 'package:flutter/material.dart';
import '../models/network_data.dart';

class NetworkAssetList extends StatelessWidget {
  final List<NetworkData> networkData;
  final bool showDailyRevenue;

  const NetworkAssetList({
    super.key,
    required this.networkData,
    required this.showDailyRevenue,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: networkData.length,
      itemBuilder: (context, networkIndex) {
        var network = networkData[networkIndex];
        double networkValue = showDailyRevenue
            ? network.calculateDailyRevenue()
            : network.calculateTotalBalance();

        return Column(
          children: [
            _buildNetworkExpansionTile(network, networkValue),
            if (networkIndex < networkData.length - 1)
              _buildDivider(),
          ],
        );
      },
    );
  }

  Widget _buildNetworkExpansionTile(NetworkData network, double networkValue) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      child: ExpansionTile(
        title: _buildNetworkTitle(network),
        trailing: _buildNetworkTrailing(networkValue),
        children: network.assets.map((asset) => _buildAssetItem(asset)).toList(),
      ),
    );
  }

  Widget _buildNetworkTitle(NetworkData network) {
    return Row(
      children: [
        _buildNetworkImage(network),
        const SizedBox(width: 8),
        Text(
          network.network.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkImage(NetworkData network) {
    return Image.network(
      network.networkImage,
      width: 20,
      height: 20,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.broken_image,
        size: 20,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildNetworkTrailing(double networkValue) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '\$${networkValue.toStringAsFixed(showDailyRevenue ? 3 : 2)}',
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const Icon(Icons.arrow_drop_down)
      ],
    );
  }

  Widget _buildAssetItem(AssetData asset) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: _buildAssetDetails(asset),
        ),
      ),
    );
  }

  Widget _buildAssetDetails(AssetData asset) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAssetInfo(asset),
        _buildLiquidityRateChip(asset),
        _buildAssetValue(asset),
      ],
    );
  }

  Widget _buildAssetInfo(AssetData asset) {
    return Expanded(
      flex: 3,
      child: Row(
        children: [
          _buildAssetIcon(asset),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAssetSymbol(asset),
                _buildAssetAddress(asset),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetIcon(AssetData asset) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: ClipOval(
        child: Image.network(
          asset.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                asset.symbol[0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAssetSymbol(AssetData asset) {
    return Text(
      asset.symbol,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAssetAddress(AssetData asset) {
    return Text(
      '${asset.underlyingAsset.substring(0, 4)}...${asset.underlyingAsset.substring(asset.underlyingAsset.length - 4)}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 10,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLiquidityRateChip(AssetData asset) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${asset.liquidityRate.toStringAsFixed(2)}%',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildAssetValue(AssetData asset) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAssetMainValue(asset),
          _buildAssetTokenBalance(asset),
        ],
      ),
    );
  }

  Widget _buildAssetMainValue(AssetData asset) {
    return Text(
      showDailyRevenue
          ? '\$${asset.calculateDailyRevenue().toStringAsFixed(3)}'
          : '\$${asset.balanceInUSD.toStringAsFixed(2)}',
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAssetTokenBalance(AssetData asset) {
    return Text(
      '${asset.tokenBalance.toStringAsFixed(4)} ${asset.symbol}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 10,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}