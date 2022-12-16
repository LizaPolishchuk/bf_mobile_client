import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';

class ErrorAnimatedContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double? height;
  final double? width;
  final Border? border;

  ErrorAnimatedContainer(
      {Key? key,
      required this.child,
      this.padding,
      this.margin,
      this.borderRadius,
      this.height,
      this.width,
      this.border})
      : super(key: key);

  @override
  State<ErrorAnimatedContainer> createState() => ErrorAnimatedContainerState();
}

class ErrorAnimatedContainerState extends State<ErrorAnimatedContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<double> _curve;

  bool _showError = false;

  void showError() {
    _controller.forward();

    setState(() {
      _showError = true;
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _colorAnimation = TweenSequence(<TweenSequenceItem<Color?>>[
      TweenSequenceItem<Color?>(
        tween: ColorTween(begin: Colors.transparent, end: Colors.red),
        weight: 50,
      ),
      TweenSequenceItem<Color?>(
        tween: ColorTween(begin: Colors.red, end: Colors.transparent),
        weight: 50,
      ),
    ]).animate(_curve);

    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 10),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 10, end: 0),
        weight: 50,
      ),
    ]).animate(_curve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();

        setState(() {
          _showError = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          return Container(
            height: widget.height,
            width: widget.width,
            padding: widget.padding,
            margin: widget.margin,
            child: widget.child,
            decoration: BoxDecoration(
                color: Colors.white,
                border: widget.border ??
                    Border.all(
                      width: 1,
                      color: _colorAnimation.value!,
                    ),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 25),
                boxShadow: _showError
                    ? [
                        BoxShadow(
                            color: Colors.red,
                            blurRadius: _sizeAnimation.value,
                            offset: Offset(0, 0.0))
                      ]
                    : [
                        BoxShadow(
                            color: blurColor,
                            blurRadius: 8,
                            offset: Offset(0, 0.3))
                      ]),
          );
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
