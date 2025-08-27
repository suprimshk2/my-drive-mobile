import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mydrivenepal/di/service_locator.dart' as di;

import 'package:mydrivenepal/feature/auth/screen/login/developer_option_viewmodel.dart';
import 'package:mydrivenepal/feature/banner/banner_viewmodel.dart';
import 'package:mydrivenepal/feature/tasks/task_listing_viewmodel.dart';
import 'package:mydrivenepal/feature/theme/theme_provider.dart';
import 'package:mydrivenepal/feature/theme/theme_service.dart';

import 'package:mydrivenepal/navigation/navigation_routes.dart';
import 'package:mydrivenepal/widget/scaffold/bottom_bar_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/di/di.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  NotificationHelper notificationHelper = locator<NotificationHelper>();

  @override
  void initState() {
    initializedData();
    super.initState();
  }

  initializedData() async {
    // firebase notification calls
    notificationHelper.requestNotificationPermission();
    notificationHelper.requestToken();
    notificationHelper.firebaseInit(context);
    notificationHelper.backgroundHandler(context);
    notificationHelper.terminatedHandler(context);
    // await di.locator<BannerViewModel>().fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    String appName = dotenv.env['APP_NAME'] ?? '';
    SizeConfig.init(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => locator<ThemeProvider>()),
        ChangeNotifierProvider(create: (ctx) => locator<BottomBarViewModel>()),
        ChangeNotifierProvider(
            create: (ctx) => locator<DeveloperOptionViewModel>()),
        ChangeNotifierProvider(create: (ctx) => locator<BannerViewModel>()),
        ChangeNotifierProvider(
            create: (ctx) => locator<TaskListingViewmodel>()),
      ],
      builder: (ctx, child) {
        final themeService = locator<ThemeService>();

        return ScreenUtilInit(
          designSize: const Size(428, 926), // iPhone 14 Pro Max dimensions
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: appName,
              theme: themeService.lightTheme,
              darkTheme: themeService.darkTheme,
              routerConfig: navigationRouter,
            );
          },
        );
      },
    );
  }
}
