import 'package:flutter/material.dart';

import '../constants/color_constant.dart';
import '../extensions/text_style_extensions.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final VoidCallback callBack;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final IconData? iconData;
  final bool? isDisabled;
  final bool? isElevated;
  final Color? borderColor;

  const CommonButton({
    super.key,
    required this.title,
    required this.callBack,
    this.buttonColor,
    this.iconData,
    this.buttonTextColor,
    this.isDisabled,
    this.isElevated,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isDisabled ?? false ? () {} : callBack,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
              side: borderColor != null
                  ? BorderSide(color: borderColor!, width: 1.5)
                  : BorderSide.none),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(isDisabled ?? false
            ? Colors.grey
            : buttonColor ?? ColorConstant.primaryColor),
      ),
      child: SizedBox(
        height: kToolbarHeight,
        child: Center(
          child: title.isEmpty
              ? Center(
                  child: iconData != null
                      ? Icon(
                          iconData,
                          color: isDisabled ?? false
                              ? Colors.white
                              : buttonTextColor ?? Colors.white,
                        )
                      : const SizedBox(),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    iconData != null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              iconData,
                              color: isDisabled ?? false
                                  ? Colors.white
                                  : buttonTextColor ?? Colors.white,
                            ),
                          )
                        : const SizedBox(),
                    Text(
                      title,
                      style: context.titleM!.copyWith(
                        fontSize: 14,
                        color: isDisabled ?? false
                            ? Colors.white
                            : buttonTextColor ?? Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
