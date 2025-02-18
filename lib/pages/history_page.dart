import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../extensions/text_style_extensions.dart';
import '../provider/activity_provider.dart';
import '../widgets/common_appbar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    // Load activities from local storage when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<ActivityProvider>(context);

    final isLoading = homeProvider.isLoading;

    return Scaffold(
      appBar: CommonAppBar(
        context: context,
        title: 'History',
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
