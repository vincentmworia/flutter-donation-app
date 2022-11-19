class Donor {
  final String email;
  final String fullName;
  final String age;
  final Gender gender;
  final String bloodType;
  final String location;
  final int phoneNumber;

  Donor(
      {required this.email,
      required this.fullName,
      required this.age,
      required this.gender,
      required this.bloodType,
      required this.location,
      required this.phoneNumber});
}

enum Gender { male, female }
