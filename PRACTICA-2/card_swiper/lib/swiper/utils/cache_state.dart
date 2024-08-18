class CacheState<T> {
  CacheState(this._value, {CacheState<T>? previousValue})
      : _previous = previousValue;

  T _value;
  CacheState<T>? _previous;

  T get state => _value;

  set state(T newValue) {
    _previous = CacheState(_value, previousValue: _previous);
    _value = newValue;
  }

  void undo() {
    if (_previous != null) {
      _value = _previous!._value;
      _previous = _previous?._previous;
    }
  }
}