class RouteNames {
  static const String onBoarding = '/on-boarding';
  static const String login = '/login';
  static const String requestEOC = '/request-eoc';
  static const String selectEOC = '/select-eoc';
  static const String success = '/success';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String setPasswordForgot = '/set-password-forgot';
  static const String resetPassword = '/reset-password';
  static const String activateAccount = '/set-password';
  static const String setPasswordForActivation = '/set-password-for-activation';
  static const String dashboard = '/dashboard';
  static const String landing = '/landing';
  static const String noInternet = '/no-internet';
  static const String confirmation = '/confirmation';
  static const String idCard = '/id-card';
  // static const String otpVerification = '/otp-verification/:phoneNumber';
  static const String setPassword = '/forgot-password/:phoneNumber';

  // Information
  static const String info = '/info';

  static const String episodeDetail = '/episode-detail';
  static const String milestoneDetail = '/milestone-detail';

  static const String profile = '/profile';
  static const String task = '/task';

  // task-types
  static const String question = '/question';
  static const String qnr = '/qnr';
  static const String todo = '/todo';
  static const String acknowledgement = '/acknowledgement';
  static const String signature = '/signature';
  static const String message = '/message';

  // communication
  static const String chat = '/chat';

  // user mode
  static const String userMode = '/user-mode';
  static const String mainDashboard = '/main-dashboard';
}

enum AppRoute {
  onBoarding,
  login,
  requestEOC,
  selectEOC,
  success,
  forgotPassword,
  otpVerification,
  setPasswordForgot,
  resetPassword,
  dashboard,
  setPasswordForActivation,
  activateAccount,
  info,
  landing,
  idCard,
  episodeDetail,
  profile,
  milestoneDetail,
  task,
  question,
  qnr,
  todo,
  acknowledgement,
  chat,
  signature,
  message,
  mainDashboard,
  userMode,
}
