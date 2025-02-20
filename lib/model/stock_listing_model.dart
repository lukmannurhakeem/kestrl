class StockListingModel {
  final String symbol;
  final String name;
  final String exchange;
  final String assetType;
  final String ipoDate;
  final String delistingDate;
  final String status;

  StockListingModel({
    required this.symbol,
    required this.name,
    required this.exchange,
    required this.assetType,
    required this.ipoDate,
    required this.delistingDate,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'exchange': exchange,
      'assetType': assetType,
      'ipoDate': ipoDate,
      'delistingDate': delistingDate,
      'status': status,
    };
  }

  factory StockListingModel.fromJson(Map<String, dynamic> json) {
    return StockListingModel(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      exchange: json['exchange'] ?? '',
      assetType: json['assetType'] ?? '',
      ipoDate: json['ipoDate'] ?? '',
      delistingDate: json['delistingDate'] ?? '',
      status: json['status'] ?? '',
    );
  }

  factory StockListingModel.fromCsvRow(List<String> row) {
    return StockListingModel(
      symbol: row[0],
      name: row[1],
      exchange: row[2],
      assetType: row[3],
      ipoDate: row[4],
      delistingDate: row[5],
      status: row[6],
    );
  }
}

List<StockListingModel> stockListingModelFromCsv(String csvStr) {
  final List<StockListingModel> listings = [];
  final List<String> rows = csvStr.split('\n');

  // Skip the header row (first row)
  for (var i = 1; i < rows.length; i++) {
    if (rows[i].trim().isEmpty) continue;

    final List<String> columns = rows[i].split(',');
    if (columns.length >= 7) {
      // Ensure we have all required columns
      listings.add(StockListingModel.fromCsvRow(columns));
    }
  }

  return listings;
}
