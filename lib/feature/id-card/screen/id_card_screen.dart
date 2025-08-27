import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';

import '../../../di/di.dart';
import '../../../shared/shared.dart';
import '../id_card.dart';

class MemberIdCardsScreen extends StatefulWidget {
  const MemberIdCardsScreen({super.key});

  @override
  State<MemberIdCardsScreen> createState() => _MemberIdCardsScreenState();
}

class _MemberIdCardsScreenState extends State<MemberIdCardsScreen> {
  late PageController _pageController;
  final viewModel = locator<IdCardViewModel>();
  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.9);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    await viewModel.fetchIdCardList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      padding: Dimens.spacing_large,
      bottom: Dimens.spacing_large,
      appbarTitle: IdCardConstant.appBarTitle,
      child: ChangeNotifierProvider(
        create: (context) => viewModel,
        child: Consumer<IdCardViewModel>(
            builder: (context, idCardResponse, child) {
          return ResponseBuilder<List<IdCardResponseModel>>(
            response: idCardResponse.idCardListResponse,
            onRetry: () {
              getData();
            },
            onLoading: () => const CardShimmerWidget(
                height: Dimens.spacing_50, needMargin: false),
            onData: (List<IdCardResponseModel> idCardList) {
              if (idCardList.isEmpty) {
                return Center(
                  child: TextWidget(
                    text: IdCardConstant.noIdCardFound,
                    textAlign: TextAlign.left,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: idCardList.length,
                itemBuilder: (context, index) {
                  final document = idCardList[index];

                  return MemberIdCard(data: document);
                },
              );
            },
          );
        }),
      ),
    );
  }
}

class MemberIdCard extends StatelessWidget {
  final IdCardResponseModel data;
  final bool isActive;

  const MemberIdCard({
    super.key,
    required this.data,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      margin: const EdgeInsets.only(bottom: Dimens.spacing_4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.spacing_4),
        color: AppColors.transparent,
        border: Border.all(
          color: appColors.borderGraySoftAlpha50,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with logo and title
          _buildHeader(context),

          // Info rows
          ListView(
            shrinkWrap: true,
            children: [
              // eoc info section
              _buildMainInfo(context),
              const SizedBox(height: Dimens.spacing_4),

              // Episode type row header
              _buildTable(
                context,
                data.episodeTypeText,
                data.episodeBenefitDateText,
                alignRight: false,
              ),

              // episode and its benefit dates
              ...data.benefitDetails.map((episode) => _buildTable(
                  context,
                  episode.name,
                  isNotEmpty(episode.benefitDates)
                      ? episode.benefitDates
                      : 'N/A',
                  alignRight: false,
                  showTopBorder: false,
                  showBottomBorder: true)),

              const SizedBox(height: Dimens.spacing_4),
              // contact info section
              _buildContactInfo(context),

              // claims info section
              _buildClaimsInfo(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(Dimens.spacing_8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageWidget(
            fit: BoxFit.contain,
            imagePath: data.logo,
            width: Dimens.spacing_95,
            height: Dimens.spacing_50,
          ),
          const SizedBox(width: Dimens.spacing_2),
          Expanded(
            child: TextWidget(
              text: data.benefitPlan,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: appColors.textSubtle),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(context, IdCardConstant.groupNameDetail, data.groupName,
            showBorder: false),
        _buildInfoRow(
            context, IdCardConstant.benefitPlanDetail, data.benefitPlan,
            showBorder: false),
        _buildInfoRow(
            context, IdCardConstant.planCodeDetail, data.planCode ?? "N/A",
            showBorder: false),
        _buildInfoRow(context, IdCardConstant.subscriberDetail,
            data.member.subscriberNumber,
            showBorder: false),
        _buildInfoRow(context, IdCardConstant.memberDetail, data.memberFullName,
            showBorder: false),
        _buildInfoRow(context, IdCardConstant.dobDetail, data.formattedDob,
            showBorder: false),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool showBorder = true,
    bool alignRight = true,
  }) {
    final appColors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: showBorder
              ? BorderSide(color: appColors.borderGraySoftAlpha50)
              : BorderSide.none,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacing_8,
          vertical: Dimens.spacing_8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: TextWidget(
                text: label,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: appColors.textSubtle),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              flex: 3,
              child: TextWidget(
                text: value,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: appColors.textSubtle),
                textAlign: alignRight ? TextAlign.right : TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(
    BuildContext context,
    String label,
    String value, {
    bool showBottomBorder = true,
    bool showTopBorder = true,
    bool alignRight = true,
  }) {
    final appColors = context.appColors;

    return Table(
      border: TableBorder(
        top: showTopBorder
            ? BorderSide(color: appColors.borderGraySoftAlpha50)
            : BorderSide.none,
        bottom: showBottomBorder
            ? BorderSide(color: appColors.borderGraySoftAlpha50)
            : BorderSide.none,
        verticalInside: BorderSide(color: appColors.borderGraySoftAlpha50),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacing_8,
                vertical: Dimens.spacing_8,
              ),
              child: TextWidget(
                text: label,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: appColors.textSubtle),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacing_8,
                vertical: Dimens.spacing_8,
              ),
              child: TextWidget(
                text: value,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: appColors.textSubtle),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacing_large, vertical: Dimens.spacing_12),
      child: Column(
        children: [
          _buildContactRow(context, IdCardConstant.claimContactNumber,
              data.formattedClaimContactNumber),
          const SizedBox(height: Dimens.spacing_8),
          _buildContactRow(context, IdCardConstant.customerContactNumber,
              data.formattedCustomerContactNumber),
        ],
      ),
    );
  }

  Widget _buildContactRow(BuildContext context, String label, String value) {
    final appColors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: TextWidget(
            text: label,
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: appColors.textSubtle),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          flex: 2,
          child: TextWidget(
            text: value,
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: appColors.textSubtle),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildClaimsInfo(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing_large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: IdCardConstant.claimsInfo,
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: appColors.textSubtle),
          ),
          const SizedBox(height: Dimens.spacing_8),
          Padding(
            padding: const EdgeInsets.only(left: Dimens.spacing_large),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: TextWidget(
                    text: IdCardConstant.clearingHouseName,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: appColors.textSubtle),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextWidget(
                    text: data.clearingHouseName,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: appColors.textSubtle),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimens.spacing_8),
          Padding(
            padding: const EdgeInsets.only(
                left: Dimens.spacing_large, bottom: Dimens.spacing_large),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: IdCardConstant.payerId,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: appColors.textSubtle),
                  textAlign: TextAlign.left,
                ),
                TextWidget(
                  text: data.payerId,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: appColors.textSubtle),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
