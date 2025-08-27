class LoginRequestModel {
  final String userName;
  final String password;
  final String source;
  final bool rememberMe;

  LoginRequestModel({
    required this.userName,
    required this.password,
    this.source = 'phone',
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "password": password,
        "source": source,
        "rememberMe": rememberMe,
      };
}
