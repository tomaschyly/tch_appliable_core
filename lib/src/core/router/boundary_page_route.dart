import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tch_appliable_core/src/core/router_v1.dart';
import 'package:tch_appliable_core/src/ui/widgets/abstract_stateful_widget.dart';
import 'package:tch_appliable_core/utils/boundary.dart';
import 'package:tch_appliable_core/utils/widget.dart';

const kBoundaryTransitionDuration = Duration(milliseconds: 300);

class BoundaryPageRoute<T> extends MaterialPageRoute<T> {
  final Boundary boundary;
  final double? borderRadius;

  @override
  Duration get transitionDuration => kBoundaryTransitionDuration;

  /// BoundaryPageRoute initialization
  BoundaryPageRoute({
    required super.builder,
    required this.boundary,
    super.settings,
    this.borderRadius,
  });

  /// Build transitions to and from this Route
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final theBorderRadius = borderRadius;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double diffWidth = constraints.maxWidth - boundary.width;
        final double diffHeight = constraints.maxHeight - boundary.height;

        final double coefficient = (1 - animation.value);

        final double firstCoefficient = (animation.value / 0.3) < 1 ? animation.value / 0.3 : 1;
        final double secondCoefficient = firstCoefficient < 1 ? 0 : (((animation.value - 0.3) / 0.7) < 1 ? (animation.value - 0.3) / 0.7 : 1);

        final double left = boundary.x * coefficient;
        final double top = boundary.y * coefficient;

        final double width = boundary.width + (diffWidth * animation.value);
        final double height = boundary.height + (diffHeight * animation.value);

        final double actualBorderRadius = theBorderRadius != null ? (theBorderRadius * coefficient).roundToDouble() : 0;

        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(actualBorderRadius),
                child: Opacity(
                  opacity: firstCoefficient < 1 ? 0 : secondCoefficient,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BoundaryPageRouteWidget extends AbstractStatefulWidget {
  final Widget child;
  final String pushRoute;
  final Map<String, String>? pushArguments;
  final void Function()? pushBeforeAction;
  final double? borderRadius;

  /// BoundaryPageRouteWidget initialization
  const BoundaryPageRouteWidget({
    super.key,
    required this.child,
    required this.pushRoute,
    this.pushArguments,
    this.pushBeforeAction,
    this.borderRadius,
  });

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _BoundaryPageRouteWidgetState();
}

class _BoundaryPageRouteWidgetState extends AbstractStatefulWidgetState<BoundaryPageRouteWidget> with RouteAware, TickerProviderStateMixin {
  final _containerKey = GlobalKey();
  late AnimationController _animationController;
  bool _isAnimated = false;
  Boundary _childBoundary = Boundary.zero();
  Boundary _targetBoundary = Boundary.zero();
  OverlayEntry? _transitionEntry;
  Timer? _failSafeTimer;

  /// Manually dispose of resources
  @override
  void dispose() {
    routeObserver.unsubscribe(this);

    _animationController.dispose();

    _transitionEntry?.remove();
    _transitionEntry = null;

    _failSafeTimer?.cancel();
    _failSafeTimer = null;

    super.dispose();
  }

  /// Run initializations of screen on first build only
  @override
  firstBuildOnly(BuildContext context) {
    super.firstBuildOnly(context);

    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      routeObserver.subscribe(this, modalRoute as PageRoute);
    }

    _animationController = AnimationController(vsync: this, duration: kBoundaryTransitionDuration);
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: SizedBox(
          key: _containerKey,
          child: _isAnimated ? null : widget.child,
        ),
        onTap: () => pushAnimated(context),
      ),
    );
  }

  /// Build overlay entry for Boundary transition animation
  OverlayEntry _buildTransitionOverlay({
    required bool Function(double opacity) isComplete,
    required VoidCallback onComplete,
  }) {
    return OverlayEntry(
      builder: (BuildContext context) {
        final double diffWidth = _targetBoundary.width - _childBoundary.width;
        final double diffHeight = _targetBoundary.height - _childBoundary.height;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            final double coefficient = 1 - _animationController.value;
            final double firstCoefficient = (_animationController.value / 0.3).clamp(0.0, 1.0);
            final double opacity = 1 - firstCoefficient;

            if (_transitionEntry != null && isComplete(opacity)) {
              final theEntry = _transitionEntry!;
              _transitionEntry = null;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                theEntry.remove();
                onComplete();
              });
            }

            return Positioned(
              left: _childBoundary.x * coefficient,
              top: _childBoundary.y * coefficient,
              child: SizedBox(
                width: _childBoundary.width + diffWidth * _animationController.value,
                height: _childBoundary.height + diffHeight * _animationController.value,
                child: Opacity(
                  opacity: opacity,
                  child: child,
                ),
              ),
            );
          },
          child: widget.child,
        );
      },
    );
  }

  /// Push to the target route with Boundary transition
  void pushAnimated(BuildContext context) {
    final media = MediaQuery.of(context);

    widget.pushBeforeAction?.call();

    final theBorderRadius = widget.borderRadius;

    final renderBox = _containerKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _childBoundary = Boundary(renderBox.size.width, renderBox.size.height, position.dx, position.dy);
    _targetBoundary = Boundary(media.size.width, media.size.height, 0, 0);

    final arguments = _childBoundary.toRoutingJson();

    final thePushArguments = widget.pushArguments;
    if (thePushArguments != null) {
      arguments.addAll(thePushArguments);
    }

    if (theBorderRadius != null) {
      arguments['router-boundary-radius'] = theBorderRadius.toString();
    }

    setStateNotDisposed(() {
      _isAnimated = true;

      addPostFrameCallback((timeStamp) {
        _transitionEntry = _buildTransitionOverlay(
          isComplete: (opacity) => opacity < 0.01,
          onComplete: () {},
        );

        Overlay.of(context).insert(_transitionEntry!);

        _animationController.forward();

        pushNamed(context, widget.pushRoute, arguments: arguments);

        _failSafeTimer = Timer(
          Duration(milliseconds: ((kBoundaryTransitionDuration.inMilliseconds / 3) * 1.25).toInt()),
          () {
            final theTransitionEntry = _transitionEntry;
            if (theTransitionEntry != null) {
              theTransitionEntry.remove();
              _transitionEntry = null;
            }
          },
        );
      });
    });
  }

  /// This screen is now the top Route after return back to this Route from next ones
  @override
  void didPopNext() {
    super.didPopNext();

    didPopNextAnimated();
  }

  /// Run Boundary transition in reverse to get back into original state
  void didPopNextAnimated() {
    _transitionEntry = _buildTransitionOverlay(
      isComplete: (opacity) => opacity > 0.99,
      onComplete: () {
        setStateNotDisposed(() {
          _isAnimated = false;
        });
      },
    );

    Overlay.of(context).insert(_transitionEntry!);

    _animationController.reverse();

    _failSafeTimer = Timer(
      Duration(milliseconds: (kBoundaryTransitionDuration.inMilliseconds * 1.25).toInt()),
      () {
        final theTransitionEntry = _transitionEntry;
        if (theTransitionEntry != null) {
          theTransitionEntry.remove();
          _transitionEntry = null;

          addPostFrameCallback((timeStamp) {
            setStateNotDisposed(() {
              _isAnimated = false;
            });
          });
        }
      },
    );
  }
}
