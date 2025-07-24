import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:conset/models/patient_model.dart';
import 'package:conset/services/patient_services/patient_service.dart';

class PatientNotifier extends StateNotifier<List<Patient>> {
  PatientNotifier() : super([]);

  Future<void> loadPatients() async {
    try {
      final patients = await PatientService().getPatients();
      state = patients;
    } catch (e) {
      log("Error fetching patients: $e");
      print("Error fetching patients: $e");
    }
  }
}

final patientProvider = StateNotifierProvider<PatientNotifier, List<Patient>>((ref) {
  return PatientNotifier();
});
