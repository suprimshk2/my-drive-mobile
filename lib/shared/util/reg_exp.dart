class RexExpUtil {
  static final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static final RegExp strongPassword =
      RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[@#_!])(?=.*[0-9]).{8,}$');
}
