class RemoteAPIConstant {
  //Home
  static String LANDING = 'dashboard/landing';

  // Register Device
  static String REGISTER_DEVICE = 'auth/register-device';

  // Auth
  static String GOOGLE_LOGIN = '/auth/tokensign';
  static String APPLE_LOGIN = '/auth/apple/login';
  static String LOGIN = 'auth/login';
  static String VERIFY_CODE_FOR_PASSWORD_EXPIRED = 'auth/verify-code';
  static String RESET_PASSWORD = 'auth/reset-password';
  static String SEND_OTP_FOR_FORGOT_PASSWORD = 'users/resend-otp/:phoneNumber';
  static String VERIFY_OTP_FOR_FORGOT_PASSWORD = 'users/verify-otp';
  static String VALIDATE_PASSWORD = 'auth/:uuId/validate-password';
  static String SET_PASSWORD = 'auth/set-password';

  static String BIOMETRIC_SETUP = 'auth/biometric/setup';
  static String BIOMETRIC_CREATE_CHALLENGE = 'auth/biometrics/challenge';
  static String BIOMETRIC_LOGIN = 'auth/biometric/authenticate';
  static String BIOMETRIC_REMOVE = 'auth/biometric/disable';

  // Disclaimer
  static String SET_DISCLAIMER = 'users/:userId/settings';

  // User
  static String UPDATE_DEVICE = 'users/devices';
  static String LOGOUT = 'users/:userId/logout';

  // Request EOC
  static String REQUEST_EOC = 'members-request-eoc';
  static String EOC_LIST = 'episode-of-cares';

  // Information
  static String INFO_LIST = 'documents';

  static String CONVERSATION = 'conversations';

  // ID Card
  static String ID_CARD_LIST = 'users/:memberId/id-cards';

  // Episode
  static String EPISODE_LIST = 'episodes';
  static String EPISODE_DETAIL = 'episodes/:episodeId/milestones';
  static String TOPIC_LIST =
      'episodes/:episodeId/milestones/:milestoneId/topics';
  static String ALL_TASK = 'episodes/users/:userId/tasks';
  // Profile
  static String GET_USER_DATA = '/users/:userId';

  // Tasks
  static String UPDATE_QUESTION = 'episodes/question-answer';
  static String GET_TASK_BY_ID =
      'episodes/milestones/:milestoneId/tasks/:taskId?type=:type';
  static String REQUEST_SIGN =
      'episodes/:episodeId/tasks/:topicId/request-sign';
  static String UPDATE_TASK = 'episodes/task/status-update';

  //Banner
  static String BANNERS = 'banners';

  // Switch User Mode
  static String SWITCH_USER_MODE = '/auth/switch-account';

  // Fetch User Roles
  static String FETCH_USER_ROLES = '/users/roles';
}
