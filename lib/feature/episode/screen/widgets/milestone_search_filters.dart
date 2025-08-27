import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';

enum EpisodeStatusFilter {
  DUE('Due', 'DUE'),
  INPROGRESS('In Progress', 'IN PROGRESS'),
  COMPLETED('Completed', 'COMPLETED'),
  PRIMARY('Primary', 'PRIMARY'),
  ALL('All', 'ALL');

  final String displayName;
  final String value;

  const EpisodeStatusFilter(this.displayName, this.value);
}

class MilestoneSearchFilters extends StatefulWidget {
  final List<EpisodeStatusFilter> filters;
  final EpisodeStatusFilter initialFilter;
  final Function(EpisodeStatusFilter) onFilterChanged;

  const MilestoneSearchFilters({
    super.key,
    required this.filters,
    required this.initialFilter,
    required this.onFilterChanged,
  });

  @override
  State<MilestoneSearchFilters> createState() => _MilestoneSearchFiltersState();
}

class _MilestoneSearchFiltersState extends State<MilestoneSearchFilters> {
  late EpisodeStatusFilter _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacing_8),
      itemCount: widget.filters.length,
      separatorBuilder: (_, __) => SizedBox(width: Dimens.spacing_large),
      itemBuilder: (context, index) {
        final filter = widget.filters[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedFilter = filter;
            });
            widget.onFilterChanged(filter);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.spacing_large,
            ),
            decoration: BoxDecoration(
              color: _selectedFilter == filter
                  ? appColors.bgPrimaryMain
                  : AppColors.transparent,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: _selectedFilter == filter
                    ? appColors.bgPrimaryMain
                    : appColors.gray.main,
                width: 1,
              ),
            ),
            child: Center(
              child: TextWidget(
                text: filter.displayName,
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: _selectedFilter == filter
                          ? appColors.gray.subtle
                          : appColors.textInverse,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
