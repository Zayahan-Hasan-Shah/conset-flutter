import 'package:conset/core/dummy_data/patient_dummy_data.dart';
import 'package:conset/models/patient_model.dart';

class PatientService {
  // get Patient 
  Future<List<Patient>> getPatients() async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 2));
    
    // Return dummy data
    print("Fetching patients from dummy data $dummyPatients");
    return dummyPatients;
  }
}