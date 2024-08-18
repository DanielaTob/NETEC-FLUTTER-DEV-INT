import 'package:flutter_test/flutter_test.dart';
import 'package:testing_app/counter.dart';
void main() {
  group('Counter Tests', () {
    test('Counter value should be incremented', () {
      final counter = Counter();
      counter.increment();
      expect(counter.value, 1);
  });


  test('Counter value should be decremented', () {
    final counter = Counter();
    counter.increment(); // Incrementar primero para evitar negativo
    counter.decrement();
    expect(counter.value, 0);
    });
  });
}