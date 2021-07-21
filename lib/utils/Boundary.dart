import 'package:supercharged/supercharged.dart';
import 'package:tch_appliable_core/src/core/RouterV1.dart';

class Boundary {
  double width;
  double height;
  double x;
  double y;

  /// Boundary initialization
  Boundary(this.width, this.height, this.x, this.y);

  /// Boundary initialization with zero size
  Boundary.zero()
      : width = 0,
        height = 0,
        x = 0,
        y = 0;

  /// Boundary initialization from JSON map used by Router
  Boundary.fromRoutingJson(RoutingArguments arguments)
      : width = arguments['router-boundary-width']!.toDouble()!,
        height = arguments['router-boundary-height']!.toDouble()!,
        x = arguments['router-boundary-x']!.toDouble()!,
        y = arguments['router-boundary-y']!.toDouble()!;

  /// Convert into JSON map used by Router
  Map<String, String> toRoutingJson() => {
        'router-boundary-width': width.toString(),
        'router-boundary-height': height.toString(),
        'router-boundary-x': x.toString(),
        'router-boundary-y': y.toString(),
      };

  /// Validate JSON map used by Router if it contains correct arguments
  static bool validateRoutingJson(RoutingArguments arguments) =>
      arguments['router-boundary-width'] != null &&
      arguments['router-boundary-height'] != null &&
      arguments['router-boundary-x'] != null &&
      arguments['router-boundary-y'] != null;

  /// Convert the object into string
  String toString() => 'Boundary: $width $height $x $y';
}
