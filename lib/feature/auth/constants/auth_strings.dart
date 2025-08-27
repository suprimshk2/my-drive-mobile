class AuthStrings {
  static const String memberLogin = 'Member Login';
  static const String userName = 'Username*';
  static const String userNameHintText = 'Enter username';
  static const String password = 'Password*';
  static const String confirmPassword = 'Confirm Password*';
  static const String passwordHintText = 'Enter password';
  static const String rememberMe = 'Remember Me';
  static const String forgotPassword = 'Forgot Password?';
  static const String login = 'Login';
  static const String notMember = 'Not a Member?';
  static const String getStarted = 'Get Started';
  static const String startEOC = 'Learn more about starting an Episode of Care';
  static const String termsOfUse = 'Terms of Use';
  static const String privacyPolicy = 'Privacy Policy';
  static const String phoneNumber = 'Phone Number*';
  static const String phoneNumberHintText = 'Enter phone number';

  // forgot password
  static const String forgotPasswordTitle = 'Forgot Password';
  static const String requestOTP = 'Request OTP';
  static const String requestOTPTitle =
      'Your one time password will be sent to this phone number.';
  static const String backToLogin = 'Go back to login';

  // otp verification
  static const String verifyOtpTitle = 'Verify OTP';
  static const String verifyOtpDescription =
      'Please enter the one time password sent to your phone';
  static const String didntReceiveOtp = 'Didn\'t receive code? ';
  static const String verifyOtpBtnText = 'Verify';
  static const String resendOtpBtnText = 'Resend';
  static const String cancelBtnText = 'Cancel';

  static const String goToLogin = 'Go to Login';

  // set password
  static const String setPasswordTitle = 'Set Your Password';

  // change password
  static const String changePasswordTitle = 'Change Your Password';
  static const String changePasswordBtnLabel = 'Change Password';

  static const String confirmPasswordHintText = 'Confirm new password';
  static const String rulesForChangingPassword =
      'Rules to follow while changing passwords';
  static const String submitPasswordBtnLabel = 'Submit';
  static const String passwordStrengthRule =
      'Password must be at least 8 characters including at least one Uppercase, Lowercase, Special character i.e #@! and a number. Spaces are not allowed in Password.';
  static const String personalInfoRule =
      'Password should not include personal information, such as name or birth date.';
  static const String bannedPasswordRule =
      'Password should not include global banned password.';
  static const String usedPasswordRule =
      'New password cannot be the same as any of the previous 6 passwords.';
  static const String confirmPasswordRule =
      'Password and Confirm Password should be same.';

  // account-setup
  static const String setPasswordBtnLabel = 'Set Password';
  static const String welcomeToSwaddle = 'Welcome, ';
  static const String welcomeToSwaddleDescription =
      'Your account has been successfully created. To proceed, please set your password to access your account.';

  // biometric
  static const String setup_biometric = 'Setup Biometric';
  static const String setup_later = 'Setup Later';

  // password expired
  static const String passwordExpiredTitle = 'Password Expired';
  static const String passwordExpiredDescription =
      'You must create a new password. Enter your current password and your new chosen password.';

  // success screen
  static const String passwordSetSuccessTitle = 'Password Set Successfully';
  static const String passwordSetSuccessDescription =
      'Your password has been set. You may now proceed to log in.';

  static const String passwordChangedSuccessTitle = 'Password Changed';
  static const String passwordChangedSuccessDescription =
      'Your password has been changed. Please use your new password to login.';

  static const String userActivationCodeExpiryErrorMessage =
      'Your code has been expired. Please contact the admin for further assistance.';
}
