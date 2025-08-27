import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/shared/util/util.dart';

typedef OnGenderSelected = void Function(String selectedDate);

showCupertinoSelectPicker(BuildContext context, List<String> items,
    String initialValue, onGenderSelected) {
  const double kItemExtent = 32.0;

  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.transparent,
    builder: (BuildContext builder) {
      final int findIndex = items.indexOf(initialValue);
      int index = 0;

      if (index != -1) {
        index = findIndex;
      }
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        height: MediaQuery.of(context).copyWith().size.height / 4,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(
              height: kItemExtent * 3,
              child: CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: kItemExtent,
                scrollController: FixedExtentScrollController(
                  initialItem: index,
                ),
                onSelectedItemChanged: (int selectedItem) {
                  items[selectedItem];
                  onGenderSelected(items[selectedItem]);
                },
                children: List<Widget>.generate(
                  items.length,
                  (int index) {
                    return InkWell(
                      onTap: () {
                        onGenderSelected(items[index]);
                        context.pop();
                      },
                      child: Center(
                        child: Text(
                          items[index],
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
