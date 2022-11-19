class Donor {
  String? email;
  String? password;
  String? fullName;
  String? age;
  Gender? gender;
  String? bloodType;
  String? location;
  String? phoneNumber;

  Donor(
      {this.email,
      this.fullName,
      this.age,
      this.gender,
      this.bloodType,
      this.location,
      this.phoneNumber,
      this.password});
}

enum Gender { male, female }
