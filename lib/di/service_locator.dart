import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mydrivenepal/di/config/config_provider.dart';

import 'package:mydrivenepal/feature/auth/screen/forgot_password/forgot_password_viewmodel.dart';
import 'package:mydrivenepal/feature/auth/screen/login/developer_option_viewmodel.dart';
import 'package:mydrivenepal/feature/auth/screen/reset_password/reset_password_viewmodel.dart';
import 'package:mydrivenepal/feature/auth/screen/user-activation/user_activation_viewmodel.dart';
import 'package:mydrivenepal/feature/banner/banner_viewmodel.dart';
import 'package:mydrivenepal/feature/banner/data/banner_repo.dart';
import 'package:mydrivenepal/feature/banner/data/banner_repo_impl.dart';
import 'package:mydrivenepal/feature/banner/data/local/banner_local.dart';
import 'package:mydrivenepal/feature/banner/data/local/banner_local_impl.dart';
import 'package:mydrivenepal/feature/banner/data/remote/banner_remote.dart';
import 'package:mydrivenepal/feature/banner/data/remote/banner_remote_impl.dart';
import 'package:mydrivenepal/feature/communications/data/comms_repository.dart';
import 'package:mydrivenepal/feature/communications/data/comms_repository_impl.dart';
import 'package:mydrivenepal/feature/communications/data/remote/comms_remote.dart';
import 'package:mydrivenepal/feature/communications/data/remote/comms_remote_impl.dart';
import 'package:mydrivenepal/feature/communications/utils/comet_chat_init.dart';
import 'package:mydrivenepal/feature/communications/screens/comms-listing/comms_screen_viewmodel.dart';
import 'package:mydrivenepal/feature/profile/data/remote/profile_remote.dart';
import 'package:mydrivenepal/feature/profile/data/remote/profile_remote_impl.dart';
import 'package:mydrivenepal/feature/profile/screen/profile_viewmodel.dart';
import 'package:mydrivenepal/feature/tasks/data/task_repo.dart';
import 'package:mydrivenepal/feature/tasks/task_listing_viewmodel.dart';
import 'package:mydrivenepal/feature/theme/theme_service.dart';
import 'package:mydrivenepal/feature/topic/data/remote/topic_remote.dart';
import 'package:mydrivenepal/feature/topic/data/remote/topic_remote_impl.dart';
import 'package:mydrivenepal/feature/topic/data/topic_repo_impl.dart';
import 'package:mydrivenepal/provider/password_validator_viewmodel.dart';
import 'package:mydrivenepal/widget/scaffold/bottom_bar_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:mydrivenepal/data/data.dart';
import 'package:mydrivenepal/data/remote/dio_api_client_impl.dart';
import 'package:mydrivenepal/di/service_names.dart';
import 'package:mydrivenepal/feature/auth/screen/biometric/biometric_viewmodel.dart';
import 'package:mydrivenepal/feature/auth/screen/login/login_viewmodel.dart';
import 'package:mydrivenepal/feature/feature.dart';
import 'package:mydrivenepal/navigation/navigation_service.dart';

import '../feature/dashboard/dashboard_repository.dart';
import '../feature/dashboard/dashboard_repository_impl.dart';
import '../feature/dashboard/dashboard_viewmodel.dart';
import '../feature/dashboard/disclaimer_viewmodel.dart';
import '../feature/dashboard/remote/dashboard_remote.dart';
import '../feature/dashboard/remote/dashboard_remote_impl.dart';
import '../feature/episode/episode.dart';
import '../feature/info/info.dart';
import '../feature/onboarding/onboarding_viewmodel.dart';
import '../feature/request-eoc/data/remote/request_eoc_remote.dart';
import '../feature/request-eoc/data/remote/request_eoc_remote_impl.dart';
import '../feature/request-eoc/data/request_eoc_repo.dart';
import '../feature/request-eoc/data/request_eoc_repo_impl.dart';
import '../feature/request-eoc/request_eoc_viewmodel.dart';
import '../feature/tasks/data/remote/remote.dart';
import '../feature/tasks/data/remote/task_remote.dart';
import '../feature/tasks/data/task_repo_impl.dart';
import '../feature/tasks/task_viewmodel.dart';
import '../feature/topic/data/topic_repo.dart';
import '../feature/topic/topic_viewmodel.dart';
import '../feature/user-mode/user_mode.dart';
import '../shared/shared.dart';
import 'remote_config_service.dart';

import 'package:mydrivenepal/feature/profile/data/models/user_mode_model.dart';
import 'package:mydrivenepal/feature/profile/data/local/profile_local.dart';
import 'package:mydrivenepal/feature/profile/data/local/profile_local_impl.dart';
import 'package:mydrivenepal/feature/profile/data/profile_repository.dart';
import 'package:mydrivenepal/feature/profile/data/profile_repository_impl.dart';
import 'package:mydrivenepal/feature/profile/screen/profile_viewmodel.dart';
import 'package:mydrivenepal/feature/rider-registration/viewmodel/rider_registration_viewmodel.dart';

GetIt locator = GetIt.instance;

// TODO: Need to move registration to different files based on either feature or service type
Future setUpServiceLocator() async {
  // Load configuration
  final config = await ConfigProvider().loadConfig();

  var sharedPref = await SharedPrefManager.getInstance();

  // Local Storage Clients
  // locator.registerLazySingleton<LocalStorageClient>(
  //   () => SecureStorageManager(),
  //   instanceName: ServiceNames.SecureStorageManager,
  // );
  locator.registerLazySingleton<LocalStorageClient>(
    () => SharedPrefManager(
      sharedPref: sharedPref,
    ),
    instanceName: ServiceNames.SharedPrefManager,
  );

  // Remote Clients
  locator.registerLazySingleton<ApiClient>(
    () => DioApiClientImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.SharedPrefManager,
      ),
    ),
  );

  // Navigation
  locator.registerLazySingleton(
    () => NavigationService(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.SharedPrefManager,
      ),
    ),
  );

  // Theme

  locator.registerLazySingleton<ThemeLocal>(
    () => ThemeLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.SharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(
      themeLocal: locator<ThemeLocal>(),
    ),
  );
  locator.registerLazySingleton<ThemeProvider>(
    () => ThemeProvider(
      themeRepository: locator<ThemeRepository>(),
    ),
  );

  locator.registerLazySingleton<ThemeService>(
    () => ThemeService(
      themeConfig: config.themeConfig,
    ),
  );

  // Auth
  locator.registerLazySingleton<AuthLocal>(
    () => AuthLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.SharedPrefManager,
      ),
      // secureStorageManager: locator<LocalStorageClient>(
      //   instanceName: ServiceNames.SecureStorageManager,
      // ),
    ),
  );
  locator.registerLazySingleton<AuthRemote>(
    () => AuthRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authLocal: locator<AuthLocal>(),
      authRemote: locator<AuthRemote>(),
      cometChatRepo: locator<CometChatInit>(),
    ),
  );
  locator.registerFactory<BiometricViewModel>(
    () => BiometricViewModel(
      cometChatRepo: locator<CometChatInit>(),
      authRepository: locator<AuthRepository>(),
    ),
  );

  locator.registerFactory<LoginViewModel>(
    () => LoginViewModel(
      cometChatInit: locator<CometChatInit>(),
      authRepository: locator<AuthRepository>(),
    ),
  );

  // User Mode Feature
  locator.registerLazySingleton<UserModeLocal>(
    () => UserModeLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.SharedPrefManager,
      ),
    ),
  );

  locator.registerLazySingleton<UserModeRepository>(
    () => UserModeRepositoryImpl(
      userModeLocal: locator<UserModeLocal>(),
    ),
  );

  locator.registerFactory<UserModeViewModel>(
    () => UserModeViewModel(
      userModeRepository: locator<UserModeRepository>(),
    ),
  );

  // Ride Booking Feature
  locator.registerLazySingleton<RideBookingLocal>(
    () => RideBookingLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.SharedPrefManager,
      ),
    ),
  );

  locator.registerLazySingleton<RideBookingRepository>(
    () => RideBookingRepositoryImpl(
      rideBookingLocal: locator<RideBookingLocal>(),
    ),
  );

  locator.registerFactory<PassengerModeViewModel>(
    () => PassengerModeViewModel(
      repository: locator<RideBookingRepository>(),
    ),
  );

  locator.registerFactory<BottomBarViewModel>(
    () => BottomBarViewModel(),
  );
  locator.registerLazySingleton<DeveloperOptionViewModel>(
    () => DeveloperOptionViewModel(
      authLocal: locator<AuthLocal>(),
      remoteConfigService: locator<RemoteConfigService>(),
    ),
  );

  locator.registerLazySingleton<RequestEocRemote>(
    () => RequestEocRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<RequestEocRepo>(
    () => RequestEocRepoImpl(
      requestEocRemote: locator<RequestEocRemote>(),
    ),
  );
  locator.registerFactory<RequestEpisodeOfCareViewModel>(
    () => RequestEpisodeOfCareViewModel(
      requestEocRepo: locator<RequestEocRepo>(),
    ),
  );
  locator.registerFactory<ForgotPasswordViewmodel>(
    () => ForgotPasswordViewmodel(
      authRepository: locator<AuthRepository>(),
    ),
  );

  locator.registerFactory<PasswordValidatorViewModel>(
    () => PasswordValidatorViewModel(
      authRepository: locator<AuthRepository>(),
    ),
  );

  locator.registerFactory<OnBoardingViewModel>(
    () => OnBoardingViewModel(
      authRepository: locator<AuthRepository>(),
    ),
  );
  locator.registerFactory<ResetPasswordViewmodel>(
    () => ResetPasswordViewmodel(
      authRepository: locator<AuthRepository>(),
    ),
  );

  locator.registerFactory<UserActivationViewmodel>(
    () => UserActivationViewmodel(
      authRepository: locator<AuthRepository>(),
    ),
  );
  locator.registerSingleton<RemoteConfigService>(
    RemoteConfigService(
      FirebaseRemoteConfig.instance,
    ),
  );
  // Information
  locator.registerLazySingleton<InfoRemote>(
    () => InfoRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<InfoRepo>(
    () => InfoRepoImpl(
      infoRemote: locator<InfoRemote>(),
    ),
  );
  locator.registerFactory<InfoViewModel>(
    () => InfoViewModel(
      infoRepo: locator<InfoRepo>(),
    ),
  );
  locator.registerLazySingleton(
    () => NotificationHelper(),
  );
  locator.registerLazySingleton<CometChatInit>(
    () => CometChatInit(notificationHelper: locator<NotificationHelper>()),
  );

  /*
    todo: remove this later. 
    This was done for comet chat response from API 
    but now we are using the comet chat classes.
  */
  locator.registerLazySingleton<CommsRemote>(
    () => CommsRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<CommsRepository>(
    () => CommsRepositoryImpl(
      commsRemote: locator<CommsRemote>(),
    ),
  );
  locator.registerFactory<CommsScreenViewModel>(
    () => CommsScreenViewModel(authLocal: locator<AuthLocal>()),
  );

  // ID Card
  locator.registerLazySingleton<IdCardRemote>(
    () => IdCardRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<IdCardRepo>(
    () => IdCardRepoImpl(
      idCardRemote: locator<IdCardRemote>(),
      authLocal: locator<AuthLocal>(),
    ),
  );
  locator.registerFactory<IdCardViewModel>(
    () => IdCardViewModel(
      idCardRepo: locator<IdCardRepo>(),
    ),
  );

  // Episode
  locator.registerLazySingleton<EpisodeRemote>(
    () => EpisodeRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<EpisodeRepo>(
    () => EpisodeRepoImpl(
      episodeRemote: locator<EpisodeRemote>(),
    ),
  );
  locator.registerFactory<EpisodeViewModel>(
    () => EpisodeViewModel(
      episodeRepo: locator<EpisodeRepo>(),
    ),
  );
  locator.registerFactory<EpisodeDetailViewModel>(
    () => EpisodeDetailViewModel(
      episodeRepo: locator<EpisodeRepo>(),
    ),
  );

  // Profile
  locator.registerFactory<ProfileRemote>(
    () => ProfileRemoteImpl(
      apiClient: locator<ApiClient>(),
      authLocal: locator<AuthLocal>(),
    ),
  );

  locator.registerLazySingleton<ProfileViewmodel>(
    () => ProfileViewmodel(
      profileRepository: locator<ProfileRepository>(),
    ),
  );

  // Profile Feature Registration
  locator.registerLazySingleton<ProfileLocal>(
    () => ProfileLocalImpl(
      localStorageClient: locator<LocalStorageClient>(
        instanceName: ServiceNames.SharedPrefManager,
      ),
    ),
  );

  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      profileLocal: locator<ProfileLocal>(),
      profileRemote: locator<ProfileRemote>(),
      authLocal: locator<AuthLocal>(), // Add this line
    ),
  );

  // Task
  locator.registerLazySingleton<TaskRemote>(
    () => TaskRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<TaskRepo>(
    () => TaskRepoImpl(
      taskRemote: locator<TaskRemote>(),
      authLocal: locator<AuthLocal>(),
    ),
  );
  locator.registerLazySingleton<TaskListingViewmodel>(
      () => TaskListingViewmodel(taskRepo: locator<TaskRepo>()));

  locator.registerFactory<TaskViewModel>(
    () => TaskViewModel(
      taskRepo: locator<TaskRepo>(),
    ),
  );

  // Topic
  locator.registerLazySingleton<TopicRemote>(
    () => TopicRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<TopicRepo>(
    () => TopicRepoImpl(
      topicRemote: locator<TopicRemote>(),
    ),
  );
  locator.registerFactory<TopicViewModel>(
    () => TopicViewModel(
      topicRepo: locator<TopicRepo>(),
    ),
  );

  locator.registerFactory<DashboardViewModel>(
    () => DashboardViewModel(
      taskRepo: locator<TaskRepo>(),
      episodeRepo: locator<EpisodeRepo>(),
    ),
  );

  // Dashboard
  locator.registerLazySingleton<DashboardRemote>(
    () => DashboardRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      authLocal: locator<AuthLocal>(),
      dashboardRemote: locator<DashboardRemote>(),
    ),
  );
  locator.registerFactory<DisclaimerViewModel>(
    () => DisclaimerViewModel(
      dashboardRepository: locator<DashboardRepository>(),
    ),
  );

  // Banner
  locator.registerLazySingleton<BannerLocal>(
    () => BannerLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.SharedPrefManager,
      ),
    ),
  );

  locator.registerLazySingleton<BannerRemote>(
    () => BannerRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );

  locator.registerLazySingleton<BannerRepo>(
    () => BannerRepoImpl(
      bannerRemote: locator<BannerRemote>(),
      bannerLocal: locator<BannerLocal>(),
    ),
  );

  locator.registerSingleton<BannerViewModel>(
    BannerViewModel(
      bannerRepo: locator<BannerRepo>(),
    ),
  );

  // Rider Registration Feature
  locator.registerLazySingleton<RiderRegistrationViewModel>(
    () => RiderRegistrationViewModel(),
  );
}
