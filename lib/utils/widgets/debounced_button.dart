import 'dart:async';

import 'package:flutter/material.dart';

class DebouncedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  DebouncedButton({required this.onPressed, required this.child});

  @override
  _DebouncedButtonState createState() => _DebouncedButtonState();
}

class _DebouncedButtonState extends State<DebouncedButton> {
  Timer? _timer;
  late ValueNotifier<bool> _isEnabled;

  @override
  void initState() {
    super.initState();

    _isEnabled = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isEnabled,
      builder: (context, isEnabled, child) => GestureDetector(
        onTap: isEnabled ? _onButtonPressed : null,
        child: child,
      ),
      child: widget.child,
    );
  }

  void _onButtonPressed() {
    _isEnabled.value = false;
    widget.onPressed();
    _timer = Timer(Duration(milliseconds: 700), () {
      _isEnabled.value = true;
    });
  }
}
