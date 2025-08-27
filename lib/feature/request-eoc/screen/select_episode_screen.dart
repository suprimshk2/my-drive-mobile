import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/request-eoc/request_eoc_viewmodel.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/widget/search/search_textfield.dart';
import 'package:provider/provider.dart';

import '../../../shared/shared.dart';
import '../../../shared/util/colors.dart';
import '../../../shared/util/dimens.dart';
import '../../../widget/widget.dart';
import '../constant/constant.dart';
import '../data/model/eoc_list_response_model.dart';
import '../data/model/request_eoc_request_model.dart';

class EocSelectScreen extends StatefulWidget {
  const EocSelectScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EocSelectScreen> createState() => _EocSelectScreenState();
}

class _EocSelectScreenState extends State<EocSelectScreen> {
  final TextEditingController _searchController = TextEditingController();
  final eocViewModel = locator<RequestEpisodeOfCareViewModel>();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      eocViewModel.setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ScaffoldWidget(
      padding: 0,
      onPressedIcon: () => context.pop(),
      showAppbar: true,
      showBackButton: true,
      appbarTitle: "",
      resizeToAvoidBottomInset: false,
      child: Consumer<RequestEpisodeOfCareViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacing_large,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            color: appColors.textInverse,
                          ),
                      text: "Hello ${viewModel.fullName}",
                    ),
                    const SizedBox(height: Dimens.spacing_large),
                    TextWidget(
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            color: appColors.textInverse,
                          ),
                      text: "What service are you looking for?",
                    ),
                    const SizedBox(height: Dimens.spacing_large),
                  ],
                ),
              ),
              const SizedBox(height: Dimens.spacing_large),
              _buildSearchField(viewModel),
              Expanded(
                child: viewModel.eocListUseCase.isLoading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimens.spacing_large,
                        ),
                        child: const CardShimmerWidget(),
                      )
                    : _buildEocList(viewModel),
              ),
              _buildSubmitButton(context, viewModel),
              const SizedBox(height: Dimens.spacing_large),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField(RequestEpisodeOfCareViewModel viewModel) {
    final appColors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spacing_large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: appColors.textInverse),
            text: "Search Episode of Care",
          ),
          const SizedBox(height: Dimens.spacing_8),
          SearchTextField(
            controller: _searchController,
            onChanged: (value) => viewModel.setSearchQuery(value),
            hintText: "Eg. Total Knee Replacement",
          ),
        ],
      ),
    );
  }

  Widget _buildEocList(RequestEpisodeOfCareViewModel viewModel) {
    if (viewModel.eocListUseCase.data?.rows.isEmpty ??
        true && !viewModel.eocListUseCase.isLoading) {
      final appColors = context.appColors;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          Center(
            child: TextWidget(
              textAlign: TextAlign.center,
              text: 'No episodes of care found',
              style: Theme.of(context).textTheme.bodyText.copyWith(
                    color: appColors.textInverse,
                  ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: viewModel.eocListUseCase.data?.rows.length ?? 0,
      itemBuilder: (context, index) {
        final eoc = viewModel.eocListUseCase.data!.rows[index];
        return _EocListItem(
          eoc: eoc,
          isSelected: viewModel.eocUuid == eoc.uuid,
          onTap: () => viewModel.setEocInfo(
            bundleDisplayName: eoc.name,
            eocUuid: eoc.uuid,
            eocName: eoc.name,
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, RequestEpisodeOfCareViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spacing_large,
      ),
      child: RoundedFilledButtonWidget(
        context: context,
        isLoading: viewModel.requestEocUseCase.isLoading,
        label: RequestEocConstant.submit,
        onPressed: () => observeResponse(context, viewModel),
      ),
    );
  }
}

observeResponse(
  BuildContext context,
  RequestEpisodeOfCareViewModel viewModel,
) async {
  FocusManager.instance.primaryFocus?.unfocus();
  viewModel.setEocInfo(
    bundleDisplayName: viewModel.bundleDisplayName,
    eocUuid: viewModel.eocUuid,
    eocName: viewModel.eocName,
  );

  final request = EocRequestModel(
    firstName: viewModel.firstName,
    lastName: viewModel.lastName,
    dob: viewModel.dob,
    subscriberId: viewModel.subscriberId,
    phone: viewModel.phone,
    email: viewModel.email,
    contactVia: viewModel.contactVia,
    bundleDisplayName: viewModel.bundleDisplayName,
    eocUuid: viewModel.eocUuid,
    eocName: viewModel.eocName,
  );
  if (viewModel.eocUuid.isEmpty) {
    showToast(context, RequestEocConstant.selectEOCErrorMessage,
        isSuccess: false);
    return;
  } else {
    await viewModel.requestEoc(request);
  }

  if (viewModel.requestEocUseCase.hasCompleted) {
    if (!context.mounted) return;
    context.goNamed(
      AppRoute.success.name,
      extra: {'isRequestEOC': true},
    );
  } else {
    showToast(context, viewModel.requestEocUseCase.exception?.toString() ?? "",
        isSuccess: false);
    context.goNamed(AppRoute.login.name);
  }
}

class _EocListItem extends StatelessWidget {
  final EocListResponseModel eoc;
  final bool isSelected;
  final VoidCallback onTap;

  const _EocListItem({
    required this.eoc,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacing_large),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: eoc.name,
              style: Theme.of(context).textTheme.bodyText.copyWith(
                    color: appColors.textInverse,
                  ),
            ),
            isSelected
                ? Icon(
                    Icons.check_circle_rounded,
                    color: appColors.bgPrimaryMain,
                    size: Dimens.spacing_extra_large,
                  )
                : Icon(
                    Icons.circle_outlined,
                    color: appColors.borderGraySoftAlpha50,
                    size: Dimens.spacing_extra_large,
                  ),
          ],
        ),
      ),
    );
  }
}
