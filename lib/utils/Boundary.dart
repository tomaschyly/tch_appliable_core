class Boundary {
  double width;
  double height;
  double x;
  double y;

  /// Boundary initialization
  Boundary(this.width, this.height, this.x, this.y);

  /// Convert the object into string
  String toString() => 'Boundary: $width $height $x $y';
}
