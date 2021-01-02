extension ListExtension<E> on List<E> {
  /// Returns the first element that satisfies the given predicate or null.
  E? firstWhereOrNull(bool test(E element)) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}
