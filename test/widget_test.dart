import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isolate_demo/screens/demo_screen.dart';
import 'package:isolate_demo/widgets/animation_panel.dart';

Widget _demo() {
  // male n, aby byl vypocet v testu hned hotovy
  return const MaterialApp(home: DemoScreen(moznosti: [10], vychoziN: 10));
}

void main() {
  testWidgets('obrazovka ma animaci a obe tlacitka', (tester) async {
    await tester.pumpWidget(_demo());

    expect(find.byType(AnimationPanel), findsOneWidget);
    expect(find.text('Spocitat v UI vlakne'), findsOneWidget);
    expect(find.text('Spocitat v isolatu'), findsOneWidget);
  });

  testWidgets('tlacitko isolatu spocita vysledek', (tester) async {
    await tester.pumpWidget(_demo());

    await tester.tap(find.text('Spocitat v isolatu'));
    await tester.pump();
    // isolate potrebuje realny event loop, proto runAsync
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
    await tester.pump();

    expect(find.textContaining('fib(10) = 55'), findsOneWidget);
  });

  testWidgets('tlacitko UI vlakna spocita vysledek', (tester) async {
    await tester.pumpWidget(_demo());

    await tester.tap(find.text('Spocitat v UI vlakne'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.textContaining('fib(10) = 55'), findsOneWidget);
  });
}
