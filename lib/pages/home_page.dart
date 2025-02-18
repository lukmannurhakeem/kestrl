import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/color_constant.dart';
import '../provider/stock_provider.dart';
import '../widgets/common_appbar.dart';
import '../widgets/common_button_widget.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String? selectedType;
  const HomePage({
    super.key,
    this.selectedType,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<StockProvider>(
          context,
          listen: false,
        ).loadStocks();
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      Provider.of<StockProvider>(context, listen: false).searchStocks(query);
    });
  }

  Future<void> _viewStockDetails(String symbol) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Center(
          child: CircularProgressIndicator(
            color: ColorConstant.primaryColor,
          ),
        ),
      );

      // Get stock overview data
      final dio = Dio();
      final overviewResponse = await dio.get(
        'https://www.alphavantage.co/query',
        queryParameters: {
          'function': 'OVERVIEW',
          'symbol': symbol,
          'apikey': '7SVSXP9IBZ4BOB8R',
        },
      );

      // Get time series data for the chart
      final timeSeriesResponse = await dio.get(
        'https://www.alphavantage.co/query',
        queryParameters: {
          'function': 'TIME_SERIES_MONTHLY',
          'symbol': symbol,
          'apikey': '7SVSXP9IBZ4BOB8R',
        },
      );

      // Close loading dialog
      Navigator.pop(context);

      if (overviewResponse.statusCode == 200 && timeSeriesResponse.statusCode == 200) {
        final stockDetails = overviewResponse.data;
        final timeSeriesData = timeSeriesResponse.data;
        _showEnhancedStockDetailsDialog(stockDetails, timeSeriesData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load stock details')),
        );
      }
    } catch (e) {
      // Close loading dialog if there's an error
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  List<FlSpot> _prepareChartData(Map<String, dynamic> timeSeriesData) {
    final spots = <FlSpot>[];

    if (timeSeriesData.containsKey('Monthly Time Series')) {
      final monthlyData = timeSeriesData['Monthly Time Series'] as Map<String, dynamic>;
      final sortedDates = monthlyData.keys.toList()..sort();

      // Get last 24 months (2 years) or fewer if not available
      final recentDates = sortedDates.reversed.take(24).toList().reversed.toList();

      for (int i = 0; i < recentDates.length; i++) {
        final date = recentDates[i];
        final closePrice = double.tryParse(monthlyData[date]['4. close']) ?? 0.0;
        spots.add(FlSpot(i.toDouble(), closePrice));
      }
    }

    return spots;
  }

  void _showEnhancedStockDetailsDialog(Map<String, dynamic> details, Map<String, dynamic> timeSeriesData) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');
    final percentFormatter = NumberFormat.percentPattern();
    final chartData = _prepareChartData(timeSeriesData);
    final currentPrice =
        details['LatestPrice'] ?? timeSeriesData['Monthly Time Series']?.values.first['4. close'] ?? 'N/A';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorConstant.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              details['Symbol'] ?? 'N/A',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              details['Name'] ?? 'N/A',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Key Metrics Card
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key Metrics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),

                      // Current Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current Price',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            currentPrice is String && currentPrice != 'N/A'
                                ? currencyFormatter.format(double.tryParse(currentPrice) ?? 0)
                                : 'N/A',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 24),

                      // Market Cap
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Market Cap',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            details['MarketCapitalization'] != null && details['MarketCapitalization'] != 'None'
                                ? _formatLargeNumber(double.tryParse(details['MarketCapitalization'].toString()) ?? 0)
                                : 'N/A',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Dividend Yield
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dividend Yield',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            details['DividendYield'] != null &&
                                    details['DividendYield'] != 'None' &&
                                    details['DividendYield'] != '0'
                                ? '${(double.tryParse(details['DividendYield'].toString()) ?? 0 * 100).toStringAsFixed(2)}%'
                                : 'N/A',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // 52 Week High/Low
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '52-Week High/Low',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${details['52WeekHigh'] ?? 'N/A'} / ${details['52WeekLow'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Chart
                if (chartData.isNotEmpty)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Performance (Last ${chartData.length} Months)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: true),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      // Show only a few month markers
                                      if (value.toInt() % (chartData.length ~/ 4) == 0) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: TextStyle(fontSize: 10),
                                        );
                                      }
                                      return Text('');
                                    },
                                    reservedSize: 30,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: true),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: chartData,
                                  isCurved: true,
                                  barWidth: 3,
                                  color: ColorConstant.primaryColor,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: ColorConstant.primaryColor.withOpacity(0.2),
                                  ),
                                  dotData: FlDotData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'No historical data available',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),

                // Additional Info
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Company Info',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildDetailItem('Industry', details['Industry']),
                      _buildDetailItem('Sector', details['Sector']),
                      _buildDetailItem('Exchange', details['Exchange']),
                      _buildDetailItem('PE Ratio', details['PERatio']),
                      _buildDetailItem('EPS', details['EPS']),
                      SizedBox(height: 16),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        details['Description'] ?? 'No description available',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(16),
                  child: CommonButton(
                    title: 'Close',
                    callBack: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatLargeNumber(double number) {
    if (number >= 1000000000000) {
      return '\$${(number / 1000000000000).toStringAsFixed(2)}T';
    } else if (number >= 1000000000) {
      return '\$${(number / 1000000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '\$${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '\$${(number / 1000).toStringAsFixed(2)}K';
    } else {
      return '\$${number.toStringAsFixed(2)}';
    }
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'N/A',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(StockProvider provider) {
    if (provider.isSearching) {
      return Center(
        child: CircularProgressIndicator(
          color: ColorConstant.primaryColor,
        ),
      );
    }

    if (provider.searchResults.isEmpty) {
      if (provider.searchQuery.isEmpty) {
        return ListView.builder(
          itemCount: provider.stocks.length,
          itemBuilder: (context, index) {
            final stock = provider.stocks[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: InkWell(
                onTap: () => _viewStockDetails(stock.symbol),
                child: ListTile(
                  title: Text(
                    stock.symbol,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(stock.name),
                  trailing: Chip(
                    label: Text(
                      stock.exchange,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: ColorConstant.primaryColor,
                  ),
                ),
              ),
            );
          },
        );
      }
      return Center(
        child: Text('No results found for "${provider.searchQuery}"'),
      );
    }

    return ListView.builder(
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        final result = provider.searchResults[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: InkWell(
            onTap: () => _viewStockDetails(result.symbol),
            child: ListTile(
              title: Text(
                result.symbol,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result.name),
                  Text(
                    '${result.region} • ${result.currency}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Text(
                'Score: ${(double.parse(result.matchScore) * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: ColorConstant.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(context: context, title: 'Stock Listings', hasBackButton: false),
      body: Consumer<StockProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstant.primaryColor,
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadStocks(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.stocks.isEmpty) {
            return Center(
              child: Text('No stocks found'),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search stocks...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              Expanded(
                child: _buildSearchResults(provider),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CommonButton(
        title: 'Filter by Exchange',
        callBack: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => ExchangeFilterSheet(),
          );
        },
      ),
    );
  }
}

class ExchangeFilterSheet extends StatelessWidget {
  final List<String> exchanges = ['NYSE', 'NASDAQ', 'AMEX'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Exchange',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...exchanges.map((exchange) => ListTile(
                title: Text(exchange),
                onTap: () {
                  Provider.of<StockProvider>(context, listen: false).filterByExchange(exchange);
                  Navigator.pop(context);
                },
              )),
          SizedBox(height: 16),
          CommonButton(
            title: 'Show All',
            callBack: () {
              Provider.of<StockProvider>(context, listen: false).loadStocks();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
