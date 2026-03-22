import 'package:flutter/material.dart';

class FadeAnimationPageRoute<T> extends MaterialPageRoute<T> {
  /// FadeAnimationPageRoute initialization
  FadeAnimationPageRoute({
    required super.builder,
    super.settings,
  });

  /// Build transitions to and from this Route
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(secondaryAnimation),
        child: child,
      ),
    );
  }
}
