import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/shared/shared.dart';

typedef OnDateSelected = void Function(DateTime selectedDate);

showCupertinoDatePicker(
    BuildContext context, String date, OnDateSelected onDateSelected) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.transparent,
    builder: (BuildContext builder) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        height: MediaQuery.of(context).copyWith().size.height / 3,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                maximumDate: DateTime.now(),
                initialDateTime: isNotEmpty(date)
                    ? getDateFromString(date)
                    : getPreviousYearDate(),
                onDateTimeChanged: (DateTime newDate) {
                  onDateSelected(newDate);
                },
                mode: CupertinoDatePickerMode.date,
              ),
            ),
          ],
        ),
      );
    },
  );
}
