import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/data/model/developer_option_model.dart';
import 'package:mydrivenepal/di/service_locator.dart' as di;
import 'package:mydrivenepal/feature/auth/screen/login/developer_option_viewmodel.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/data/data.dart';
import 'package:mydrivenepal/di/di.dart';
import 'package:mydrivenepal/widget/dropdown/drop_down_menu_widget.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';

class DeveloperOption extends StatefulWidget {
  const DeveloperOption({super.key});

  @override
  State<DeveloperOption> createState() => _DeveloperOptionState();
}

class _DeveloperOptionState extends State<DeveloperOption> {
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  initializeData() {
    di.locator<DeveloperOptionViewModel>().getDeveloperOptions();
  }

  @override
  Widget build(BuildContext context) {
    final ApiClient dioClient = locator<ApiClient>();
    final viewModel = Provider.of<DeveloperOptionViewModel>(context);
    final List<DeveloperOptionModel> developerOptionList =
        viewModel.developerOptionList;

    // // Todo use the list from viewModel.
    // final List<DeveloperOptionModel> developerOptionList = [
    //   DeveloperOptionModel(env: "DEV", baseUrl: "https://dev.api.com/api/main"),
    //   DeveloperOptionModel(env: "QA", baseUrl: "https://qa.api.com/api/main"),
    //   DeveloperOptionModel(env: "UAT", baseUrl: "https://uat.api.com/api/main")
    // ];

    String envName = viewModel.baseUrl;

    List<DropdownMenuItem> dropDownMenuItems =
        developerOptionList.map((DeveloperOptionModel item) {
      return DropdownMenuItem(
        value: item.baseUrl,
        child: Text(item.env),
      );
    }).toList();

    return ScaffoldWidget(
      showBackButton: true,
      appbarTitle: "Choose Environment",
      showAppbar: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.spacing_12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropDownMenuWidget(
              name: "Developer Option",
              label: "Development Environment",
              hint: "Select Environment",
              value: envName,
              items: dropDownMenuItems,
              onChanged: (value) {
                envName = value;
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RoundedFilledButtonWidget(
                  context: context,
                  label: "Change",
                  onPressed: () async {
                    dioClient.updateBaseUrl(envName);
                    final isChanged =
                        await viewModel.onChangeEnvironment(envName);
                    if (isChanged) {
                      viewModel.setBaseUrl(envName);
                      context.pop();

                      showToast(context, EnvChangedSnackBar, isSuccess: true);
                    } else {
                      showToast(context, EnvChangedErrorSnackBar,
                          isSuccess: false);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
