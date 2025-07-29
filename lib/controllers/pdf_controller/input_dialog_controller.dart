import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputDialogNotifier extends StateNotifier<bool> {
  InputDialogNotifier() : super(false);

  void setLoading(bool isLoading) => state = isLoading;
}

final inputDialogProvider =
    StateNotifierProvider<InputDialogNotifier, bool>((ref) {
  return InputDialogNotifier();
});