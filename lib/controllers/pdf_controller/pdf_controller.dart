import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State to toggle editing mode
final isEditingProvider = StateProvider<bool>((ref) => false);

/// State to hold the filled PDF file path
final filledPdfPathProvider = StateProvider<String?>((ref) => null);

/// State for text/signature overlays on top of the PDF
final textOverlaysProvider = StateProvider<List<Widget>>((ref) => []);