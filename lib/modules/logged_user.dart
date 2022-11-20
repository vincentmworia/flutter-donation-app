class LoggedUser {
  final String id;
  final String email;
  final String fullName;
  final String gender;
  final bool allowedInApp;

  LoggedUser(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.gender,
      required this.allowedInApp});
}
