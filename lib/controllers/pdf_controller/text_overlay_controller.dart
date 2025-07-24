import 'dart:typed_data';
import 'package:conset/screen/bottom_navigation/screens/patient_details/widget/draggable_widget/draggable_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textOverlaysProvider = StateProvider<List<Widget>>((ref) => []);

extension TextOverlayActions on StateController<List<Widget>> {
  void addTextOverlay(Offset offset, String text) {
    state = [
      ...state,
      DraggableOverlayWidget(
        offset: offset,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    ];
  }

  void addSignatureOverlay(Offset offset, String label, Uint8List imageBytes) {
    state = [
      ...state,
      DraggableOverlayWidget(
        offset: offset,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Image.memory(imageBytes, width: 100, height: 50),
          ],
        ),
      ),
    ];
  }
}
