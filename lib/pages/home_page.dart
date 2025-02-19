import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/color_constant.dart';
import '../extensions/text_style_extensions.dart';
import '../provider/stock_provider.dart';
import '../routes/routes_path.dart';
import '../services/navigation_service.dart';
import '../widgets/common_appbar.dart';
import '../widgets/common_button_widget.dart';
import 'package:dio/dio.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<StockProvider>(context, listen: false).loadStocks();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
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
              color: ColorConstant.white,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: InkWell(
                onTap: () {
                  NavigationService.instance.pushNamed(
                    Routes.STOCK_DETAIL,
                    arguments: stock.symbol,
                  );
                },
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stock.exchange,
                          style: context.titleS
                              ?.copyWith(color: ColorConstant.primaryColor)),
                      Text(stock.symbol, style: context.titleL),
                    ],
                  ),
                  subtitle: Text(stock.name),
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
          color: ColorConstant.white,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: InkWell(
            onTap: () {
              NavigationService.instance.pushNamed(
                Routes.STOCK_DETAIL,
                arguments: result.symbol,
              );
            },
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.exchange,
                    style: context.titleS
                        ?.copyWith(color: ColorConstant.primaryColor),
                  ),
                  Text(result.symbol, style: context.titleL),
                ],
              ),
              subtitle: Text(result.name),
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
        context: context,
        title: 'Stock Listings',
        hasBackButton: false,
        action: <IconButton>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite,
              color: ColorConstant.primaryColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Consumer<StockProvider>(
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
                child: ElevatedButton(
                  onPressed: () => provider.loadStocks(),
                  child: Text(
                    'Retry',
                    style: context.bodyM,
                  ),
                ),
              );
            }

            if (provider.stocks.isEmpty) {
              return Center(
                child: Text(
                  'No stocks found',
                  style: context.bodyL,
                ),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Search stocks...',
                      suffixIcon:
                          Icon(Icons.search, color: ColorConstant.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: ColorConstant.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: ColorConstant.white, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: ColorConstant.grey, width: 1),
                      ),
                    ),
                    onSubmitted: _onSearchChanged,
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
      ),
    );
  }
}
