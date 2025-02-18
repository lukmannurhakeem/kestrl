class StockSearchResult {
  final String symbol;
  final String name;
  final String type;
  final String region;
  final String marketOpen;
  final String marketClose;
  final String timezone;
  final String currency;
  final String matchScore;

  StockSearchResult({
    required this.symbol,
    required this.name,
    required this.type,
    required this.region,
    required this.marketOpen,
    required this.marketClose,
    required this.timezone,
    required this.currency,
    required this.matchScore,
  });

  factory StockSearchResult.fromCsvRow(List<String> row) {
    return StockSearchResult(
      symbol: row[0],
      name: row[1],
      type: row[2],
      region: row[3],
      marketOpen: row[4],
      marketClose: row[5],
      timezone: row[6],
      currency: row[7],
      matchScore: row[8],
    );
  }
}

List<StockSearchResult> stockSearchFromCsv(String csvStr) {
  final List<StockSearchResult> results = [];
  final List<String> rows = csvStr.split('\n');

  // Skip the header row
  for (var i = 1; i < rows.length; i++) {
    if (rows[i].trim().isEmpty) continue;

    final List<String> columns = rows[i].split(',');
    if (columns.length >= 9) {
      results.add(StockSearchResult.fromCsvRow(columns));
    }
  }

  return results;
}
