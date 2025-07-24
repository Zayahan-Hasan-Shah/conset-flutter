import 'package:conset/core/form_assets/form_assets.dart';
import 'package:conset/models/patient_model.dart';

List<Patient> dummyPatients = [
  Patient(
    mrNo: '1006',
    firstName: 'Asma',
    middleName: 'Othman',
    lastName: 'Al Hammadi',
    fullName: 'Asma Othman Al Hammadi',
    sex: 'Female',
    birthDate: '1981-11-10',
    nationality: 'UAE',
    phone: '7567567423423',
    isVIP: false,
    pdfUrls: [
      FormAssets.pfr004001,
      FormAssets.pfr004003,
    ],
  ),
  Patient(
    mrNo: '1007',
    firstName: 'Ahmed',
    middleName: 'Salim',
    lastName: 'Al Nuaimi',
    fullName: 'Ahmed Salim Al Nuaimi',
    sex: 'Male',
    birthDate: '1975-06-25',
    nationality: 'UAE',
    phone: '0501234567',
    isVIP: true,
    pdfUrls: [
      FormAssets.pfr004001,
    ],
  ),
  Patient(
    mrNo: '1008',
    firstName: 'Laila',
    middleName: 'Noor',
    lastName: 'Al Mazrouei',
    fullName: 'Laila Noor Al Mazrouei',
    sex: 'Female',
    birthDate: '1992-04-15',
    nationality: 'UAE',
    phone: '0509988776',
    isVIP: false,
    pdfUrls: [
      FormAssets.pfr004001,
      FormAssets.pfr004004,
      FormAssets.pfr004003, 
    ],
  ),
];
