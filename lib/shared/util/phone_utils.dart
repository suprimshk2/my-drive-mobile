class PhoneUtils {
  static String maskPhoneNumber(String phoneNumber) {
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length != 10) {
      return phoneNumber;
    }

    return '(${digitsOnly.substring(0, 3)}) ****${digitsOnly.substring(7)}';
  }

  static String getCleanedPhoneNumber(String phoneNumber) {
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    return digitsOnly;
  }
}
