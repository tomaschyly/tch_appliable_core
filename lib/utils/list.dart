/// Convenience class for easy autoimport
class ListExtensionDummy {}

extension ListExtension<E> on List<E> {
  /// Maps the list into new list, but keep only unique values
  Iterable<T> mapUnique<T>(T toElement(E e)) {
    return map(toElement).toSet().toList();
  }
}
