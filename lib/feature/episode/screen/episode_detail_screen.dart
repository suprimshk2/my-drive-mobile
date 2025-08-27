import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/feature/episode/data/model/episode_detail_response_model.dart';
import 'package:mydrivenepal/feature/episode/data/model/milestone_detail_screen_params.dart';
import 'package:mydrivenepal/feature/episode/data/model/milestone_response_model.dart';
import 'package:mydrivenepal/feature/episode/screen/widgets/milestone_card_widget.dart';
import 'package:mydrivenepal/feature/episode/screen/widgets/milestone_search_filters.dart';
import 'package:mydrivenepal/feature/episode/screen/widgets/support_card_widget.dart';
import 'package:mydrivenepal/feature/episode/utils/episode_utils.dart';

import 'package:mydrivenepal/feature/profile/widgets/profile_info_widget.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/debounce.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/search/search_textfield.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../di/di.dart';
import '../../../shared/shared.dart';
import '../../../widget/shimmer/episode_detail_shimmer.dart';
import '../episode.dart';

class EpisodeDetailScreen extends StatefulWidget {
  final int episodeId;

  const EpisodeDetailScreen({super.key, required this.episodeId});

  @override
  State<EpisodeDetailScreen> createState() => _EpisodeDetailScreenState();
}

class _EpisodeDetailScreenState extends State<EpisodeDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  final _searchController = TextEditingController();

  final _debouncer = Debouncer(milliseconds: 1000);

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debouncer.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  final _episodeDetailViewModel = locator<EpisodeDetailViewModel>();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    _episodeDetailViewModel.fetchEpisodeDetail(
        episodeId: widget.episodeId.toString(), isMilestoneSearch: false);
  }

  Future<void> _onRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ScaffoldWidget(
      padding: 0,
      top: 0,
      bottom: 0,
      showAppbar: true,
      child: ChangeNotifierProvider<EpisodeDetailViewModel>(
        create: (context) => _episodeDetailViewModel,
        child: Consumer<EpisodeDetailViewModel>(
            builder: (context, episodeViewModel, child) {
          final support = episodeViewModel.supportData;

          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            enablePullDown: true,
            enablePullUp: false,
            child: ResponseBuilder<TransformedEpisode>(
              onLoading: () => const EpisodeDetailShimmer(),
              response: episodeViewModel.episodeDetailResponse,
              onRetry: () => getData(),
              onData: (TransformedEpisode episodeDetail) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderContent(episodeDetail),
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: EpisodeConstant.overview),
                        Tab(text: EpisodeConstant.milestones),
                        Tab(text: EpisodeConstant.support),
                      ],
                      padding: EdgeInsets.zero,
                      labelStyle: Theme.of(context).textTheme.bodyTextBold,
                      labelColor: appColors.textPrimary,
                      unselectedLabelStyle:
                          Theme.of(context).textTheme.bodyText,
                      unselectedLabelColor: appColors.textSubtle,
                      indicatorColor: appColors.bgPrimaryMain,
                      indicatorWeight: 2.0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding:
                          EdgeInsets.symmetric(horizontal: Dimens.spacing_12),
                      dividerColor: appColors.borderGraySoftAlpha50,
                      dividerHeight: 0.5,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildOverviewTab(episodeViewModel.overviewData!),
                          _buildMilestonesTab(episodeViewModel),
                          _buildSupportTab(support),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Padding _buildHeaderContent(TransformedEpisode episodeDetail) {
    final appColors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing_large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            textAlign: TextAlign.left,
            text: episodeDetail.name,
            style: Theme.of(context).textTheme.subtitle.copyWith(
                  color: appColors.textInverse,
                ),
          ),
          SizedBox(height: 16.h),
          TextWidget(
            textAlign: TextAlign.left,
            text: episodeDetail.episodeOfCare.bundle.name,
            style: Theme.of(context).textTheme.subtitle.copyWith(
                  color: appColors.textInverse,
                ),
          ),
          SizedBox(height: 16.h),
          getEpisodeStatus(context, episodeDetail.status),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(AdaptedEpisodeOverview overviewData) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimens.spacing_6),
        child: Column(
          children: [
            ProfileInfoWidget(
              itemTitle: EpisodeConstant.facility,
              itemDesc: overviewData.facility?.name ?? 'N/A',
            ),
            ProfileInfoWidget(
              itemTitle: EpisodeConstant.provider,
              itemDesc: overviewData.provider?.name ?? 'N/A',
            ),
            ProfileInfoWidget(
              itemTitle: EpisodeConstant.clinic,
              itemDesc: overviewData.clinic?.name ?? 'N/A',
            ),
            ProfileInfoWidget(
              itemTitle: EpisodeConstant.procedureDate,
              itemDesc: overviewData.procedureDate ?? 'N/A',
            ),
            ProfileInfoWidget(
              itemTitle: EpisodeConstant.benefitPeriod,
              itemDesc: overviewData.benefitDate,
            ),
            ProfileInfoWidget(
              itemTitle: EpisodeConstant.createdDate,
              itemDesc: overviewData.createdDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestonesTab(
    EpisodeDetailViewModel episodeViewModel,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: Dimens.spacing_large),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacing_8,
            ),
            child: SearchTextField(
              onSubmitted: (value) async {
                _searchController.clear();
                episodeViewModel.isSearching = false;
                episodeViewModel.searchQuery = null;
                _episodeDetailViewModel.fetchEpisodeDetail(
                    episodeId: widget.episodeId.toString(),
                    isMilestoneSearch: true);
                FocusScope.of(context).unfocus();
              },
              hintText: EpisodeConstant.searchMilestone,
              controller: _searchController,
              isSearching: episodeViewModel.isSearching,
              onChanged: (value) {
                String query = value;
                if (query.length > 2) {
                  episodeViewModel.isSearching = true;
                  episodeViewModel.searchQuery = query;
                  _debouncer.run(() {
                    _episodeDetailViewModel.fetchEpisodeDetail(
                        episodeId: widget.episodeId.toString(),
                        isMilestoneSearch: true);
                  });
                } else if (query.isEmpty) {
                  episodeViewModel.searchQuery = null;
                  episodeViewModel.isSearching = false;
                  _episodeDetailViewModel.fetchEpisodeDetail(
                      episodeId: widget.episodeId.toString(),
                      isMilestoneSearch: true);
                  FocusScope.of(context).unfocus();
                } else {
                  //TODO: refactor later
                  episodeViewModel.searchQuery = null;
                  episodeViewModel.isSearching = false;
                }
              },
              onSuffixPressed: () {
                _searchController.clear();
                episodeViewModel.isSearching = false;
                episodeViewModel.searchQuery = null;
                _episodeDetailViewModel.fetchEpisodeDetail(
                    episodeId: widget.episodeId.toString(),
                    isMilestoneSearch: true);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          SizedBox(height: Dimens.spacing_large),
          SizedBox(
            height: 40.h,
            child: MilestoneSearchFilters(
              filters: EpisodeStatusFilter.values,
              initialFilter: episodeViewModel.episodeStatusFilter,
              onFilterChanged: (newFilter) {
                episodeViewModel.episodeStatusFilter = newFilter;
                _episodeDetailViewModel.fetchEpisodeDetail(
                    episodeId: widget.episodeId.toString(),
                    isMilestoneSearch: true);
              },
            ),
          ),
          ResponseBuilder<List<AdaptedMilestone>>(
            response: episodeViewModel.milestoneSearchUseCase,
            onRetry: () {
              getData();
            },
            onLoading: () {
              return CardShimmerWidget(
                height: 130.h,
                count: 5,
              );
            },
            onData: (List<AdaptedMilestone> milestoneData) {
              if (milestoneData.isEmpty) {
                return SizedBox(
                  height: 0.5.sh,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: Dimens.spacing_large),
                      TextWidget(
                        text: EpisodeConstant.noMilestoneFound,
                        textAlign: TextAlign.left,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  vertical: Dimens.spacing_large,
                  horizontal: Dimens.spacing_8,
                ),
                scrollDirection: Axis.vertical,
                itemCount: milestoneData.length,
                itemBuilder: (context, index) {
                  final AdaptedMilestone milestone = milestoneData[index];

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: Dimens.spacing_8,
                    ),
                    child: MilestoneCard(
                      status: milestone.status ?? "",
                      onViewTask: () {
                        final milestoneParams = MilestoneDetailScreenParams(
                          episodeId: milestone.episodeId,
                          name: milestone.name,
                          description: milestone.description,
                          topics: milestone.topics,
                          milestoneId: milestone.id,
                          startDate: milestone.startDate,
                          relativeStartDate: milestone.relativeStartDate,
                          procedureDate: milestone.procedureDate,
                        );

                        context.pushNamed(
                          AppRoute.milestoneDetail.name,
                          extra: milestoneParams,
                        );
                      },
                      title: milestone.name,
                      description: milestone.description,
                      date: episodeViewModel.getMilestoneDisplayDate(milestone),
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSupportTab(
    List<SupportPersonWithDesignation> support,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacing_8, vertical: Dimens.spacing_large),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: support.length > 1
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: support
                .map((supportPerson) => SupportCard(
                      userId: supportPerson.id.toString(),
                      width: 0.42.sw,
                      userName: supportPerson.fullName,
                      category: supportPerson.designation,
                    ))
                .toList(),
          ),
          // SizedBox( //TODO: need this code later
          //   height: 220.h,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: support.length,
          //     padding: EdgeInsets.symmetric(horizontal: Dimens.spacing_8),
          //     itemBuilder: (context, index) {
          //       final SupportPersonWithDesignation supportPerson =
          //           support[index];

          //       return SupportCard(
          //         height: double.infinity,
          //         width: 0.42.sw,
          //         userName: supportPerson.fullName,
          //         category: supportPerson.designation,
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
