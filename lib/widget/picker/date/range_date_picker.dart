import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateCalenderWidget extends StatefulWidget {
  const DateCalenderWidget({super.key, required this.onSelectionChanged});

  final Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;

  @override
  State<DateCalenderWidget> createState() => _DateCalenderWidgetState();
}

class _DateCalenderWidgetState extends State<DateCalenderWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 348,
      child: Column(
        children: [
          SfDateRangePicker(
            onSelectionChanged: widget.onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.range,
            enablePastDates: false,
            showNavigationArrow: true,
            backgroundColor: Theme.of(context).cardColor,
          ),
          ButtonWidget(
            label: "Ok",
            onPressed: () {
              context.pop();
            },
          )
        ],
      ),
    );
  }
}
