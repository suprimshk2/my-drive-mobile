import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/feature/info/screen/documents.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import '../../../di/service_locator.dart';
import '../../../shared/shared.dart';
import '../../../widget/widget.dart';
import '../info.dart';
import 'links.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen>
    with SingleTickerProviderStateMixin {
  final viewModel = locator<InfoViewModel>();
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();

    super.dispose();
  }

  getInfoList() async {
    await viewModel.fetchDocumentsList(isInitialFetch: true);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ScaffoldWidget(
      padding: 0,
      bottom: 0,
      showBackButton: false,
      appbarTitle: InfoConstant.appBarTitle,
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: InfoConstant.documentsTitle),
              Tab(text: InfoConstant.linksTitle),
            ],
            controller: _tabController,
            tabAlignment: TabAlignment.center,
            isScrollable: true,
            padding: EdgeInsets.zero,
            labelStyle: Theme.of(context).textTheme.bodyTextBold,
            labelColor: appColors.textPrimary,
            unselectedLabelStyle: Theme.of(context).textTheme.bodyText,
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
              children: const [
                DocumentsScreen(),
                LinksScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
