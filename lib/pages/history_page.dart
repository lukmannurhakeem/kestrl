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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider =
          Provider.of<ActivityProvider>(context, listen: false);
      if (homeProvider.selectedTypes.isNotEmpty) {
        homeProvider.loadSavedActivitiesByTypes(homeProvider.selectedTypes);
      } else {
        homeProvider.loadSavedActivities();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<ActivityProvider>(context);
    final activityList = homeProvider.list;
    final isLoading = homeProvider.isLoading;

    return Scaffold(
      appBar: CommonAppBar(
        context: context,
        title: 'History',
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (activityList == null || activityList.isEmpty)
              ? const Center(child: Text('No activities yet'))
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Center(
                    child: ListView.builder(
                      itemCount: activityList.length,
                      itemBuilder: (context, index) {
                        final activity = activityList[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${index + 1}. ',
                                      style: context.titleS,
                                    ),
                                    Expanded(
                                      child: Text(
                                        activity.activity ?? "Activity",
                                        style: context.titleS,
                                      ),
                                    ),
                                  ],
                                ),
                                if (activity.type != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Type: ${activity.type}',
                                      style: context.bodyS,
                                    ),
                                  ),
                                if (activity.participants != null)
                                  Text(
                                    'Participants: ${activity.participants}',
                                    style: context.bodyS,
                                  ),
                                if (activity.price != null)
                                  Text(
                                    'Price: RM ${activity.price!.toStringAsFixed(2)}',
                                    style: context.bodyS,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
