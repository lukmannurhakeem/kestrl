import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/color_constant.dart';
import '../provider/stock_provider.dart';
import '../widgets/common_appbar.dart';
import '../widgets/common_button_widget.dart';

class StockDetailPage extends StatefulWidget {
  String details;
  StockDetailPage({
    super.key,
    required this.details,
  });

  @override
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StockProvider>(context, listen: false)
          .loadStockDetails(widget.details);
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        context: context,
        title: 'Details',
        action: <IconButton>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border,
              color: ColorConstant.primaryColor,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.maxFinite,
        child: SingleChildScrollView(child: Consumer<StockProvider>(
          builder: (context, provider, child) {
            final detail = provider.stockDetails;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail['Symbol'] ?? 'N/A',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.primaryColor,
                            ),
                          ),
                          Text(
                            detail['Name'] ?? 'N/A',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildDetailItem('Industry', detail['Industry']),
                _buildDetailItem('Sector', detail['Sector']),
                _buildDetailItem('Exchange', detail['Exchange']),
                _buildDetailItem('Market Cap', detail['MarketCapitalization']),
                _buildDetailItem('PE Ratio', detail['PERatio']),
                _buildDetailItem('Dividend Yield', detail['DividendYield']),
                _buildDetailItem('52 Week High', detail['52WeekHigh']),
                _buildDetailItem('52 Week Low', detail['52WeekLow']),
                _buildDetailItem('EPS', detail['EPS']),
                SizedBox(height: 16),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  detail['Description'] ?? 'No description available',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),
              ],
            );
          },
        )),
      ),
    );
  }
}
