extension ListExtension<E> on List<E> {
  /// Returns the first element that satisfies the given predicate or null.
  E? firstWhereOrNull(bool test(E element)) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  /// Returns the last element that satisfies the given predicate or null
  E? lastWhereOrNull(bool test(E element), {E orElse()?}) {
    try {
      late E result;
      bool foundMatching = false;
      for (E element in this) {
        if (test(element)) {
          result = element;
          foundMatching = true;
        }
      }
      if (foundMatching) return result;
      if (orElse != null) return orElse();
      throw new StateError("No element");
    } catch (e) {
      return null;
    }
  }
}
