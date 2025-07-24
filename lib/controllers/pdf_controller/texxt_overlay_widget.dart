import 'dart:typed_data';

import 'package:conset/screen/bottom_navigation/screens/patient_details/widget/draggable_widget/draggable_overlay_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextOverlayNotifier extends StateNotifier<List<Widget>> {
  TextOverlayNotifier() : super([]);

  void addTextOverlay(Offset offset, String text) {
    state = [
      ...state,
      DraggableOverlayWidget(
        offset: offset,
        child: Text(text, style: const TextStyle(fontSize: 18)),
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
            Text(label, style: const TextStyle(fontSize: 12)),
            Image.memory(imageBytes, width: 150),
          ],
        ),
      ),
    ];
  }

  void clear() => state = [];
}
