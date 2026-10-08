import 'dart:isolate';

int fibonacci(int n) {
  if (n < 0) throw ArgumentError('n musi byt nezaporne');
  if (n < 2) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

Future<int> fibonacciVIsolatu(int n) {
  return Isolate.run(() => fibonacci(n));
}
