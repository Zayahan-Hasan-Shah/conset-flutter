import 'package:flutter_riverpod/flutter_riverpod.dart';

final patientFormsProvider = StateNotifierProvider.family<
    PatientFormsNotifier, List<Map<String, dynamic>>, String>(
  (ref, mrNo) => PatientFormsNotifier(),
);

class PatientFormsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  PatientFormsNotifier() : super([]);

  void loadForms(List<Map<String, dynamic>> forms) {
    state = [...forms];
  }

  void markFormAsSigned(String formPath, String newPath) {
    final updated = state.map((form) {
      if (form['pdf'] == formPath) {
        return {
          ...form,
          'pdf': newPath,
          'isSigned': true,
        };
      }
      return form;
    }).toList();
    state = updated;
  }

  List<Map<String, dynamic>> get signed =>
      state.where((form) => form['isSigned'] == true).toList();

  List<Map<String, dynamic>> get unsigned =>
      state.where((form) => form['isSigned'] == false).toList();
}
