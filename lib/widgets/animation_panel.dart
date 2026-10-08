import 'package:flutter/material.dart';

// Nekonecna animace - kdyz se zasekne, bezi vypocet v UI vlakne.
class AnimationPanel extends StatefulWidget {
  const AnimationPanel({super.key});

  @override
  State<AnimationPanel> createState() => _AnimationPanelState();
}

class _AnimationPanelState extends State<AnimationPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: RotationTransition(
            turns: _controller,
            child: const Icon(Icons.sync, size: 40),
          ),
        ),
      ),
    );
  }
}
