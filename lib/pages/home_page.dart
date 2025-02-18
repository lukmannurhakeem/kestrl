import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/color_constant.dart';
import '../provider/stock_provider.dart';
import '../widgets/common_appbar.dart';
import '../widgets/common_button_widget.dart';

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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
          context: context, title: 'Stock Listings', hasBackButton: false),
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
                  Provider.of<StockProvider>(context, listen: false)
                      .filterByExchange(exchange);
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
