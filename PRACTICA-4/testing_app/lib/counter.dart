class Counter {
  int _counter = 0;
  void increment() {
    _counter++;
  }

  void decrement() {
    _counter--;
  }

  int get value => _counter;
  
}