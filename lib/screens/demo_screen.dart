import 'package:flutter/material.dart';

import '../logic/fibonacci.dart';
import '../widgets/animation_panel.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({
    super.key,
    this.moznosti = const [38, 40, 42],
    this.vychoziN = 40,
  });

  final List<int> moznosti;
  final int vychoziN;

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  late int _n;

  bool _uiBezi = false;
  String? _uiVysledek;

  bool _isoBezi = false;
  String? _isoVysledek;

  @override
  void initState() {
    super.initState();
    _n = widget.vychoziN;
  }

  bool get _beziNeco => _uiBezi || _isoBezi;

  String _formatujCas(int ms) {
    if (ms < 1000) return '$ms ms';
    return '${(ms / 1000).toStringAsFixed(1)} s';
  }

  Future<void> _spocitejVUi() async {
    setState(() {
      _uiBezi = true;
      _uiVysledek = null;
    });
    // kratka pauza, aby se stihl prekreslit text "Pocitam..."
    await Future.delayed(const Duration(milliseconds: 100));
    final stopky = Stopwatch()..start();
    final vysledek = fibonacci(_n); // tady zamrzne UI
    stopky.stop();
    if (!mounted) return;
    setState(() {
      _uiBezi = false;
      _uiVysledek =
          'fib($_n) = $vysledek\ncas: ${_formatujCas(stopky.elapsedMilliseconds)}';
    });
  }

  Future<void> _spocitejVIsolatu() async {
    setState(() {
      _isoBezi = true;
      _isoVysledek = null;
    });
    final stopky = Stopwatch()..start();
    final vysledek = await fibonacciVIsolatu(_n);
    stopky.stop();
    if (!mounted) return;
    setState(() {
      _isoBezi = false;
      _isoVysledek =
          'fib($_n) = $vysledek\ncas: ${_formatujCas(stopky.elapsedMilliseconds)}';
    });
  }

  Widget _karta({
    required String nadpis,
    required String popis,
    required String tlacitko,
    required VoidCallback? onPressed,
    required bool bezi,
    required String? vysledek,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(nadpis, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(popis, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: bezi ? null : onPressed,
              child: Text(tlacitko),
            ),
            const SizedBox(height: 8),
            if (bezi)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Pocitam...'),
                ],
              )
            else if (vysledek != null)
              Text(
                vysledek,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else
              const Text('Zatim nespusteno.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isolates demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AnimationPanel(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Pocitat fib(n), n = '),
                DropdownButton<int>(
                  value: _n,
                  items: [
                    for (final n in widget.moznosti)
                      DropdownMenuItem(value: n, child: Text('$n')),
                  ],
                  onChanged: _beziNeco
                      ? null
                      : (v) {
                          if (v != null) setState(() => _n = v);
                        },
                ),
              ],
            ),
            const SizedBox(height: 8),
            _karta(
              nadpis: 'UI vlakno',
              popis: 'Vypocet blokuje hlavni isolate, animace se zasekne.',
              tlacitko: 'Spocitat v UI vlakne',
              onPressed: _beziNeco ? null : _spocitejVUi,
              bezi: _uiBezi,
              vysledek: _uiVysledek,
            ),
            const SizedBox(height: 8),
            _karta(
              nadpis: 'Isolate.run',
              popis: 'Vypocet bezi vedle v isolatu, animace jede dal.',
              tlacitko: 'Spocitat v isolatu',
              onPressed: _beziNeco ? null : _spocitejVIsolatu,
              bezi: _isoBezi,
              vysledek: _isoVysledek,
            ),
          ],
        ),
      ),
    );
  }
}
