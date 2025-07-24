class Patient {
  final String mrNo;
  final String firstName;
  final String middleName;
  final String lastName;
  final String fullName;
  final String sex;
  final String birthDate;
  final String nationality;
  final String phone;
  final bool isVIP;
  final List<String> pdfUrls;

  Patient({
    required this.mrNo,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.fullName,
    required this.sex,
    required this.birthDate,
    required this.nationality,
    required this.phone,
    required this.isVIP,
    required this.pdfUrls,
  });
}
