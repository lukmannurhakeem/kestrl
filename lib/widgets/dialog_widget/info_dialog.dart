import 'package:flutter/material.dart';

import '../../constants/color_constant.dart';
import '../../extensions/text_style_extensions.dart';
import '../../services/dialog_services.dart';
import '../../services/navigation_service.dart';
import '../common_button_widget.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    super.key,
    required this.title,
    required this.info,
    required this.confirmText,
    this.cancelText,
    this.cancelCallback,
    this.confirmCallback,
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.icon,
    this.confirmIcon,
    this.cancelIcon,
    required this.navigationService,
  });

  final NavigationService navigationService;
  final String title;
  final String info;
  final String confirmText;
  final String? cancelText;
  final VoidCallback? cancelCallback;
  final VoidCallback? confirmCallback;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final Widget? icon;
  final IconData? confirmIcon;
  final IconData? cancelIcon;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Align(
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: width * 0.8,
              maxWidth: width * 0.83,
            ),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[100]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                      title: Text(title), trailing: const Icon(Icons.close)),
                  Container(
                    color: Colors.white,
                    width: width * 0.83,
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.1, horizontal: width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        icon ?? const SizedBox.shrink(),
                        SizedBox(
                          height: icon != null ? 10.0 : 0.0,
                        ),
                        Text(info),
                      ],
                    ),
                  ),
                  // Spacer(),
                  Container(
                    width: width * 0.83,
                    height: 0.2,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        cancelText == null
                            ? const SizedBox.shrink()
                            : TextButton(
                                onPressed: cancelCallback ??
                                    () {
                                      DialogService.closeDialog();
                                    },
                                child: Text(
                                  cancelText ?? '',
                                  style: context.titleM!.copyWith(
                                      color: ColorConstant.primaryColor),
                                ),
                              ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: width * 0.04,
                          ),
                          height: 40,
                          child: CommonButton(
                            title: confirmText,
                            callBack: confirmCallback ??
                                () {
                                  DialogService.closeDialog();
                                },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
