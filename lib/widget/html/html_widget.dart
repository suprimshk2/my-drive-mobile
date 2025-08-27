import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlDataWidget extends StatelessWidget {
  const HtmlDataWidget(
      {super.key, this.onLinkTap, required this.data, this.textStyle});

  final String data;
  final Function(String, Map<String, String>?, Element?)? onLinkTap;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(data, textStyle: textStyle,
        customStylesBuilder: (element) {
      if (element.localName == "ul") {
        return {'margin-left': '0', 'padding-left': '20px'};
      }

      return null;
    });
  }
}
