import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../constants/color_constant.dart';
import '../extensions/text_style_extensions.dart';
import '../provider/activity_provider.dart';
import '../routes/routes_path.dart';
import '../services/navigation_service.dart';
import '../widgets/common_appbar.dart';
import '../widgets/common_button_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<MainPage> {
  // Track selected type (single selection)
  String? selectedType;

  @override
  void initState() {
    super.initState();
    // Load activities from local storage when the page initializes
    onPlatformInit();
  }

  onPlatformInit() async {
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    activityProvider.getSaveSelectedTypes();
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);
    final activityList = activityProvider.preferType;
    final isLoading = activityProvider.isLoading;
    final theme = Theme.of(context);

    selectedType = activityProvider.selectedTypes;

    print('test ${activityProvider.selectedTypes}');

    return Scaffold(
      appBar: CommonAppBar(
          context: context, title: 'Hendshake', hasBackButton: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your preferred type (Optional)',
              style: context.titleM,
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: activityList.isEmpty
                        ? const Center(
                            child: Text('No preferred types available'))
                        : ListView.builder(
                            itemCount: activityList.length,
                            itemBuilder: (context, index) {
                              final activity = activityList[index];
                              final isSelected = selectedType == activity;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // If already selected, deselect it
                                    if (isSelected) {
                                      selectedType = null;
                                    } else {
                                      // Otherwise select this one
                                      selectedType = activity;
                                    }
                                  });

                                  // Update selected type in provider
                                  activityProvider.updateSelectedTypes(
                                      selectedType != null
                                          ? selectedType!
                                          : '');
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  color: isSelected
                                      ? ColorConstant.primaryColor
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      activity,
                                      style: context.titleS?.copyWith(
                                        color: isSelected ? Colors.white : null,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: CommonButton(
        title: 'Next',
        callBack: () {
          NavigationService.instance.pushNamed(
            Routes.HOME,
            arguments: selectedType != null ? selectedType! : '',
          );
        },
      ),
    );
  }
}
