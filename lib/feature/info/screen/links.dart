import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/search/search_textfield.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/shared.dart';
import '../../../widget/widget.dart';
import '../info.dart';
import '../widget/widget.dart';

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen>
    with AutomaticKeepAliveClientMixin {
  final viewModel = locator<InfoViewModel>();
  final TextEditingController _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_loadMore);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInfoList();
    });
  }

  getInfoList() async {
    await viewModel.fetchLinksList(isInitialFetch: true);
  }

  Future<void> _loadMore() async {
    if (_scrollController.position.pixels >=
        (_scrollController.position.maxScrollExtent - 200)) {
      await viewModel.fetchLinksList(isInitialFetch: false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final appColors = context.appColors;

    return ChangeNotifierProvider(
      create: (BuildContext context) => viewModel,
      child: Consumer<InfoViewModel>(builder:
          (BuildContext context, InfoViewModel infoRes, Widget? child) {
        // final linksList = infoRes.linksList;
        // bool hasLinks = linksList.isNotEmpty;

        // bool isNetworkError =
        //     (infoRes.infoListUseCase.exception == ErrorMessages.noConnection);
        // bool hasError = infoRes.infoListUseCase.exception != null;
        // bool isLoading = infoRes.infoListUseCase.isLoading;

        return Container(
          padding: const EdgeInsets.only(
            right: Dimens.spacing_large,
            left: Dimens.spacing_large,
          ),
          child: Column(
            children: [
              _buildSearchField(viewModel),
              Expanded(
                child: ResponseBuilder<List<InfoResponseModel>>(
                  response: infoRes.linksListUseCase,
                  onRetry: () {
                    getInfoList();
                  },
                  onLoading: () => const CardShimmerWidget(
                      height: Dimens.spacing_50, needMargin: false),
                  onData: (List<InfoResponseModel> _) {
                    final linksList = infoRes.linksList;

                    if (linksList.isEmpty) {
                      return Center(
                        child: TextWidget(
                          text: InfoConstant.noInformation,
                          textAlign: TextAlign.left,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: 70.h),
                      shrinkWrap: true,
                      itemCount: linksList.length,
                      itemBuilder: (context, index) {
                        final link = linksList[index];

                        return InformationTile.link(
                          title: link.name,
                          onTap: () {
                            launchUrl(Uri.parse(link.documentPath));
                          },
                          leadingIconColor: appColors.bgPrimaryMain,
                          trailingIconColor: appColors.bgGrayBold,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSearchField(InfoViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimens.spacing_8),
        SearchTextField(
          onSubmitted: (value) {
            viewModel.fetchLinksList(isInitialFetch: true, isSearch: true);
            FocusManager.instance.primaryFocus?.unfocus();
          },
          controller: _searchController,
          onChanged: (value) => viewModel.handleLinksSearch(value),
          hintText: InfoConstant.searchLinks,
        ),
        const SizedBox(height: Dimens.spacing_8),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
