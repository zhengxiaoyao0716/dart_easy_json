class Alias<T> {
  final T _value;

  const Alias(T value) : _value = value;

  Alias.of(Alias<T> other) : this(other._value);

  T get raw => _value;

  @override
  String toString() {
    return _value.toString();
  }

  @override
  bool operator ==(other) =>
      other.runtimeType == this.runtimeType && other._value == _value;

  @override
  int get hashCode => _value.hashCode;
}