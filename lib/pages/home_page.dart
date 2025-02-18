import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../constants/color_constant.dart';
import '../extensions/text_style_extensions.dart';
import '../provider/activity_provider.dart';
import '../routes/routes_path.dart';
import '../services/navigation_service.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedType != null && widget.selectedType!.isNotEmpty) {
        print('Selected type : ${widget.selectedType}');
        Provider.of<ActivityProvider>(context, listen: false)
            .fetchActivityByType(widget.selectedType ?? '');
        Provider.of<ActivityProvider>(context, listen: false)
            .updateSelectedTypes(widget.selectedType ?? '');
      } else {
        Provider.of<ActivityProvider>(context, listen: false).fetchActivity();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final activity = Provider.of<ActivityProvider>(context).activityModel;
    return Scaffold(
      appBar: CommonAppBar(context: context, title: 'Fetch Activity'),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstant.primaryColor,
              ), // Show loading
            );
          }
          return activity?.activity?.isEmpty == true
              ? Text('Empty')
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Activity ',
                              style: context.titleM,
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  ': ${activity?.activity.toString() ?? ''}')),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Type ',
                              style: context.titleM,
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child:
                                  Text(': ${activity?.type.toString() ?? ''}')),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Participants ',
                              style: context.titleM,
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  ': ${activity?.participants.toString() ?? ''}')),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Price ',
                              style: context.titleM,
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  ': RM${activity?.price.toString() ?? ''}')),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Link ',
                              style: context.titleM,
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  ': ${activity?.link.toString() ?? '-'}')),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Key ',
                              style: context.titleM,
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child:
                                  Text(': ${activity?.key.toString() ?? ''}')),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Price ',
                              style: context.titleM,
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  ': ${activity?.accessibility.toString() ?? ''}')),
                        ],
                      ),
                    ],
                  ),
                );
        },
      ),
      bottomNavigationBar: CommonButton(
          title: 'View History',
          callBack: () {
            NavigationService.instance.pushNamed(Routes.HISTORY);
          }),
    );
  }
}
