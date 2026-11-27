import 'package:flutter/material.dart';

class FontSizePinchDetector extends StatefulWidget {
  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;
  final VoidCallback? onFontSizeChangeEnd;
  final Widget child;
  final double minimumFontSize;
  final double maximumFontSize;

  const FontSizePinchDetector({
    super.key,
    required this.fontSize,
    required this.onFontSizeChanged,
    this.onFontSizeChangeEnd,
    required this.child,
    this.minimumFontSize = 8.0,
    this.maximumFontSize = 40.0,
  });

  @override
  State<FontSizePinchDetector> createState() => _FontSizePinchDetectorState();
}

class _FontSizePinchDetectorState extends State<FontSizePinchDetector> {
  double? _startFontSize;

  void _onScaleStart(ScaleStartDetails details) {
    _startFontSize = widget.fontSize;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final startFontSize = _startFontSize;
    if (details.pointerCount < 2 || startFontSize == null) {
      return;
    }

    final fontSize = (startFontSize * details.scale).clamp(widget.minimumFontSize, widget.maximumFontSize).toDouble();
    widget.onFontSizeChanged(fontSize);
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _startFontSize = null;
    widget.onFontSizeChangeEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: widget.child,
    );
  }
}
