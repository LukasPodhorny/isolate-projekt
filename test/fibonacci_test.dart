import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:isolate_demo/logic/fibonacci.dart';

void main() {
  test('fibonacci zakladni hodnoty', () {
    expect(fibonacci(0), 0);
    expect(fibonacci(1), 1);
    expect(fibonacci(10), 55);
  });

  test('fibonacci vetsi cislo', () {
    expect(fibonacci(20), 6765);
  });

  test('fibonacci zaporne cislo hodi chybu', () {
    expect(() => fibonacci(-5), throwsArgumentError);
  });

  test('isolate vrati stejny vysledek jako normalni volani', () async {
    final presIsolate = await Isolate.run(() => fibonacci(15));
    expect(presIsolate, fibonacci(15));
    expect(presIsolate, 610);
  });
}
