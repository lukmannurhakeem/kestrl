import 'package:flutter/material.dart';

import '../extensions/text_style_extensions.dart';
import '../widgets/common_button_widget.dart';
import 'color_constant.dart';
import 'widget_extensions.dart';

class CommonNoDataError extends StatelessWidget {
  String text;
  final bool? isError;
  final VoidCallback? callback;
  final String? titleButton;

  CommonNoDataError(
      {super.key,
      required this.text,
      this.callback,
      this.titleButton,
      this.isError});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: _width,
              height: _width * 0.5,
              // child: Image.asset(isError ?? false
              //     ? 'assets/images/error_no_data_illustration.png'
              //     : 'assets/images/recycling_illustration.png'),
              child: Text(
                'No data',
                style: context.bodyM,
              )),
          Container(
            width: _width,
            margin: EdgeInsets.symmetric(
                horizontal: _width * 0.06, vertical: _width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Sorry,",
                  style: context.bodyM!.copyWith(
                    color: ColorConstant.textColor,
                  ),
                ),
              ],
            ),
          ),
          if (callback != null)
            CommonButton(title: titleButton ?? "", callBack: callback!)
                .marginSymmetric(
                    horizontal: _width * 0.08, vertical: _width * 0.1)
        ],
      ),
    );
  }
}
