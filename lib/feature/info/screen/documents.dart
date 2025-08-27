import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/search/search_textfield.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import '../../../di/service_locator.dart';
import '../../../shared/shared.dart';
import '../../../widget/widget.dart';
import '../info.dart';
import '../widget/info_tile.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
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
    await viewModel.fetchDocumentsList(isInitialFetch: true);
  }

  bool _isLoading = false;

  Future<void> _loadMore() async {
    if (_isLoading) return;
    print(_isLoading);
    if (_scrollController.position.pixels >=
        (_scrollController.position.maxScrollExtent)) {
      setState(() {
        _isLoading = true;
      });
      try {
        await viewModel.fetchDocumentsList(isInitialFetch: false);
      } catch (e) {
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  int? downloadId;
  Future<void> onDownloadFile(String path, String name, int id) async {
    try {
      downloadId = id;

      viewModel.setDownloadLoading = true;

      // Extract the actual file extension from the path
      final extension = path.split('_').last.toLowerCase();

      // Download and save the file
      final file = await writeCounter(path, name, extension);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        showSnackBar(
          context,
          SuccessMessages.downloadSuccess,
          isSuccess: true,
          actionText: "View",
          onPressed: () async {
            try {
              final result = await OpenFilex.open(file.path);
              if (result.type != ResultType.done) {
                ScaffoldMessenger.of(context).showSnackBar(
                  showSnackBar(
                    context,
                    ErrorMessages.noApplication,
                    isSuccess: false,
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                showSnackBar(
                  context,
                  "Error opening file: ${e.toString()}",
                  isSuccess: false,
                ),
              );
            }
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;

      String message = ErrorMessages.downloadError;
      if (e is SocketException) {
        message = ErrorMessages.noConnection;
      } else {
        message = "Error: ${e.toString()}";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        showSnackBar(context, message, isSuccess: false),
      );
    } finally {
      if (mounted) {
        viewModel.setDownloadLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    super.build(context);

    return ChangeNotifierProvider(
      create: (BuildContext context) => viewModel,
      child: Consumer<InfoViewModel>(builder:
          (BuildContext context, InfoViewModel infoRes, Widget? child) {
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
                    response: infoRes.documentsListUseCase,
                    onRetry: () {
                      getInfoList();
                    },
                    onLoading: () => const CardShimmerWidget(
                        height: Dimens.spacing_50, needMargin: false),
                    onData: (List<InfoResponseModel> _) {
                      final infoList = infoRes.documentsList;

                      if (infoList.isEmpty) {
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
                        itemCount: infoList.length,
                        itemBuilder: (context, index) {
                          final document = infoList[index];

                          return infoRes.isMoreDataLoading &&
                                  index == infoList.length - 1
                              ? const CardShimmerWidget(
                                  height: Dimens.spacing_50,
                                  needMargin: false,
                                  count: 1,
                                )
                              : InformationTile.document(
                                  title: document.name,
                                  onDownload: () => onDownloadFile(
                                      infoList[index].documentPath,
                                      infoList[index].name,
                                      infoList[index].id),
                                  onTap: () => onDownloadFile(
                                      infoList[index].documentPath,
                                      infoList[index].name,
                                      infoList[index].id),
                                  isLoading: infoRes.isLoading &&
                                      downloadId == document.id,
                                  loadingIndicatorColor:
                                      appColors.bgPrimaryMain,
                                  leadingIconColor: appColors.bgPrimaryMain,
                                  trailingIconColor: appColors.bgGrayBold,
                                );
                        },
                      );
                    },
                  ),
                ),
              ],
            ));
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
            viewModel.fetchDocumentsList(isInitialFetch: true, isSearch: true);
            FocusManager.instance.primaryFocus?.unfocus();
          },
          // name: "Search Documents",
          controller: _searchController,
          onChanged: (value) => onSearch(value),

          hintText: InfoConstant.searchDocuments,
        ),
        const SizedBox(height: Dimens.spacing_8),
      ],
    );
  }

  void onSearch(String value) {
    viewModel.handleDocumentsSearch(value);
  }

  @override
  bool get wantKeepAlive => true;
}
