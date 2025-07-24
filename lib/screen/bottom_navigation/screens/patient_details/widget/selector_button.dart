import 'dart:typed_data';

import 'package:conset/screen/bottom_navigation/screens/patient_details/widget/signature_screen.dart';
import 'package:flutter/material.dart';

class SelectorButton extends StatelessWidget {
  final Map<String, Rect> availablePositions;
  final void Function(String role, Uint8List signature) onSignatureCaptured;

  const SelectorButton({
    Key? key,
    required this.availablePositions,
    required this.onSignatureCaptured,
  }) : super(key: key);

  Future<void> _handleSignature(BuildContext context) async {
    final roles = availablePositions.keys.toList();

    if (roles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No signature positions available.")),
      );
      return;
    }

    final selectedRole = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Whose signature do you want to take?'),
        children: roles.map((role) {
          return SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(role),
            child: Text(role),
          );
        }).toList(),
      ),
    );

    if (selectedRole != null) {
      final signature = await showDialog<Uint8List>(
        context: context,
        builder: (context) =>
            SignatureCaptureScreen(title: '$selectedRole Signature'),
      );

      if (signature != null) {
        onSignatureCaptured(selectedRole, signature);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      tooltip: 'Add Signature',
      onPressed: () => _handleSignature(context),
    );
  }
}