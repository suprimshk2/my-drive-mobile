import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';
import '../../../di/di.dart';
import '../../../shared/shared.dart';
import '../episode.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EpisodeScreen extends StatefulWidget {
  const EpisodeScreen({super.key});

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  final viewModel = locator<EpisodeViewModel>();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    await viewModel.fetchEpisodeList();
  }

  Future<void> _onRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      padding: Dimens.spacing_large,
      bottom: Dimens.spacing_large,
      showBackButton: false,
      appbarTitle: EpisodeConstant.appBarTitle,
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        enablePullUp: false,
        physics: BouncingScrollPhysics(),
        child: ChangeNotifierProvider<EpisodeViewModel>(
          create: (context) => viewModel,
          child: Consumer<EpisodeViewModel>(
              builder: (context, episodeResponse, child) {
            return ResponseBuilder<List<TransformedEpisode>>(
              response: episodeResponse.episodeListResponse,
              onRetry: () {
                getData();
              },
              onLoading: () => CardShimmerWidget(
                height: Dimens.spacing_154,
                needMargin: false,
                count: 3,
              ),
              onData: (List<TransformedEpisode> episodeList) {
                if (episodeList.isEmpty) {
                  return Center(
                    child: TextWidget(
                      text: EpisodeConstant.noEpisodeFound,
                      textAlign: TextAlign.left,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  );
                }

                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: episodeList.length,
                  itemBuilder: (context, index) {
                    final episode = episodeList[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: Dimens.spacing_large),
                      child: EpisodeCard(
                        onViewTask: () {
                          context.pushNamed(
                            AppRoute.episodeDetail.name,
                            extra: {'episodeId': episode.id},
                          );
                        },
                        status: episode.status,
                        title: episode.name,
                        description: episode.episodeOfCare.bundle.name,
                        procedureDate: episode.procedureDate,
                      ),
                    );
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
