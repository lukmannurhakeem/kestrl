import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/color_constant.dart';
import '../constants/common_no_data_error.dart';
import '../extensions/text_style_extensions.dart';
import '../provider/stock_provider.dart';
import '../routes/routes_path.dart';
import '../services/navigation_service.dart';
import '../widgets/common_appbar.dart';

class WatchListPage extends StatefulWidget {
  @override
  _WatchListPageState createState() => _WatchListPageState();
}

class _WatchListPageState extends State<WatchListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockProvider>().loadWatchlistFromStorage();
    });
  }

  Widget _buildWatchList(StockProvider provider) {
    if (provider.isSearching) {
      return Center(
        child: CircularProgressIndicator(
          color: ColorConstant.primaryColor,
        ),
      );
    }
    if (provider.watchList.isEmpty) {
      return Center(
        child: Text(
          'No watch list added',
          style: context.bodyL,
        ),
      );
    }

    return RefreshIndicator(
      color: ColorConstant.primaryColor,
      onRefresh: () async {
        await provider.loadWatchlistFromStorage();
      },
      child: ListView.builder(
        itemCount: provider.watchList.length,
        itemBuilder: (context, index) {
          final stock = provider.watchList[index];
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
              //list
              onLongPress: () {
                provider.removeFromWatchlist(stock.name);
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
                trailing: PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (value) {
                    if (value == 'remove') {
                      provider.removeFromWatchlist(stock.name);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'remove',
                      child: Text(
                        'Remove from Watchlist',
                        style: context.bodyM,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(context: context, title: 'Watch List'),
      body: Consumer<StockProvider>(
        builder: (context, provider, child) {
          return _buildWatchList(provider);
        },
      ),
    );
  }
}
