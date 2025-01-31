import 'dart:async';
import 'package:flutter/material.dart';
import '../models/network_data.dart';
import '../services/liquidity_service.dart';
import '../widgets/toggle_switch.dart';
import '../widgets/refresh_indicator.dart';
import '../widgets/metric_card.dart';
import '../widgets/network_asset_list.dart';
import '../widgets/sidebar_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late Timer _timer;
  List<NetworkData> networkData = [];
  bool showDailyRevenue = true;
  bool _isRefreshing = false;
  ScrollController? _scrollController;
  late AnimationController _animationController;
  double _dragOffset = 0.0;
  static const double _refreshTriggerHeight = 100.0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _fetchLiquidityRates();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateLiquidityRates();
    });
  }

  void _scrollListener() {
    if (_scrollController!.position.pixels < -_refreshTriggerHeight && !_isRefreshing) {
      _startRefresh();
    }
    setState(() {
      _dragOffset = _scrollController!.position.pixels < 0
          ? _scrollController!.position.pixels.abs()
          : 0.0;
    });
  }

  Future<void> _fetchLiquidityRates() async {
    setState(() => _isRefreshing = true);
    try {
      final data = await LiquidityService().fetchLiquidityRates();
      setState(() {
        networkData = data;
        _isRefreshing = false;
      });
    } catch (e) {
      setState(() => _isRefreshing = false);
      debugPrint("Error fetching liquidity rates: $e");
    }
  }

  Future<void> _updateLiquidityRates() async {
    try {
      final data = await LiquidityService().fetchLiquidityRates();
      setState(() {
        networkData = data;
      });
    } catch (e) {
      debugPrint("Error fetching liquidity rates: $e");
    }
  }

  void _startRefresh() => _fetchLiquidityRates();

  @override
  Widget build(BuildContext context) {
    final totalDailyRevenue = LiquidityService.calculateTotalDailyRevenue(networkData);
    final totalBalance = LiquidityService.calculateTotalBalance(networkData);
    final averageAPY = LiquidityService.calculateAverageAPY(networkData);

    return Scaffold(
      key: _scaffoldKey, // Clé pour ouvrir le menu latéral
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Liquidity Dashboard'),
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer(); // Ouvre le menu latéral
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png',
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      drawer: SidebarMenu(
        onClose: () => _scaffoldKey.currentState?.closeDrawer(),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: CustomRefreshIndicator(
              dragOffset: _dragOffset,
              isRefreshing: _isRefreshing,
              animationController: _animationController,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: showDailyRevenue ? 'Estimated Daily Revenue' : 'Total Balance',
                      value: showDailyRevenue ? totalDailyRevenue : totalBalance,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: 'Average Yield',
                      value: averageAPY,
                      isPercentage: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: ToggleSwitch(
                      showDailyRevenue: showDailyRevenue,
                      onToggle: () => setState(() => showDailyRevenue = !showDailyRevenue),
                    ),
                  ),
                  NetworkAssetList(
                    networkData: networkData,
                    showDailyRevenue: showDailyRevenue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }
}
