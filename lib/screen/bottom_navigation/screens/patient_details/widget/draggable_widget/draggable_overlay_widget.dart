import 'package:flutter/material.dart';

class DraggableOverlayWidget extends StatefulWidget {
  final Widget child;
  final Offset offset;

  const DraggableOverlayWidget({
    Key? key,
    required this.child,
    required this.offset,
  }) : super(key: key);

  @override
  State<DraggableOverlayWidget> createState() => _DraggableOverlayWidgetState();
}

class _DraggableOverlayWidgetState extends State<DraggableOverlayWidget> {
  late Offset position;

  @override
  void initState() {
    super.initState();
    position = widget.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        child: widget.child,
      ),
    );
  }
}
