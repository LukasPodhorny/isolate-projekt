# Isolates demo (mvop - ukazkova aplikace)

Tema: **Isolates** - obrazovka s animaci a pomalym vypoctem, porovnani
vypoctu v UI vlakne a pres `Isolate.run`.

## Spusteni

```
flutter pub get
flutter run
```

## Co to ukazuje

Aplikace pocita `fibonacci(n)` schvalne pomalou rekurzivni verzi.
Nahore porad bezi animace, takze je videt,
co se deje s UI:

- **UI vlakno** - vypocet bezi primo v hlavnim isolatu, animace se
  na par sekund uplne zasekne
- **Isolate.run** - vypocet bezi vedle v separatnim isolatu, animace
  jede plynule dal

U kazdeho behu se zobrazi vysledek a jak dlouho trval. `n` se da
prepnout (38 / 40 / 42), vychozi je 40.

Soubory: `lib/main.dart`, `lib/logic/fibonacci.dart`,
`lib/screens/demo_screen.dart`, `lib/widgets/animation_panel.dart`.

## Testy

```
flutter test
```

Je jich 7:

- `test/fibonacci_test.dart` (4) - zakladni hodnoty fibonacciho,
  vetsi cislo (fib(20) = 6765), chyba pro zaporne n, a ze `Isolate.run`
  vrati stejny vysledek jako normalni volani
- `test/widget_test.dart` (3) - obrazovka obsahuje animaci a obe
  tlacitka, a ze po kliknuti na kazde z nich (s n = 10) vyskoci
  vysledek fib(10) = 55
