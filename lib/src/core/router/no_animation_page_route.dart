import 'package:flutter/material.dart';

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  /// NoAnimationPageRoute initialization
  NoAnimationPageRoute({
    required super.builder,
    super.settings,
  });

  /// Build transitions to and from this Route
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
