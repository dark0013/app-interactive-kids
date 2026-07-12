import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'animal_data.dart';

/// El niño escucha un sonido y elige cuál de 3 animales lo hace.
class AnimalsGameScreen extends StatefulWidget {
  const AnimalsGameScreen({super.key});

  @override
  State<AnimalsGameScreen> createState() => _AnimalsGameScreenState();
}

class _AnimalsGameScreenState extends State<AnimalsGameScreen> {
  final AudioPlayer _player = AudioPlayer();
  final Random _random = Random();

  late Animal _correct;
  late List<Animal> _options;

  bool _answered = false;
  bool _wasCorrect = false;
  String? _selectedId;
  int _score = 0;
  int _round = 0;
  bool _loadingSound = false;

  @override
  void initState() {
    super.initState();
    _player.setReleaseMode(ReleaseMode.stop);
    _nextRound(playSound: true);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _nextRound({bool playSound = true}) {
    final animals = List<Animal>.from(AnimalData.all)..shuffle(_random);
    _correct = animals.first;

    final wrong = animals.skip(1).take(2).toList();
    _options = [_correct, ...wrong]..shuffle(_random);

    setState(() {
      _answered = false;
      _wasCorrect = false;
      _selectedId = null;
      _round += 1;
    });

    if (playSound) {
      // Pequeña pausa para que el niño vea las opciones antes del sonido
      Future<void>.delayed(const Duration(milliseconds: 350), () {
        if (mounted && !_answered) _playSound();
      });
    }
  }

  Future<void> _playSound() async {
    if (_loadingSound) return;
    setState(() => _loadingSound = true);
    try {
      await _player.stop();
      await _player.play(AssetSource(_assetPath(_correct.soundAsset)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo reproducir el sonido'),
          backgroundColor: Color(0xFFC62828),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingSound = false);
    }
  }

  /// audioplayers espera la ruta sin el prefijo "assets/".
  String _assetPath(String fullPath) {
    if (fullPath.startsWith('assets/')) {
      return fullPath.substring('assets/'.length);
    }
    return fullPath;
  }

  Future<void> _onSelect(Animal animal) async {
    if (_answered) return;

    final ok = animal.id == _correct.id;
    setState(() {
      _answered = true;
      _wasCorrect = ok;
      _selectedId = animal.id;
      if (ok) _score += 1;
    });

    await _player.stop();
    // Repite el sonido del animal correcto al responder
    try {
      await _player.play(AssetSource(_assetPath(_correct.soundAsset)));
    } catch (_) {}

    await Future<void>.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    _nextRound(playSound: true);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        title: const Text(
          '🐶 Sonidos de Animales',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '⭐ $_score',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPad),
          child: Column(
            children: [
              Text(
                'Ronda $_round',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.green.shade900.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '¿Qué animal hace este sonido?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF1B5E20),
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 16),
              // Botón escuchar de nuevo
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                elevation: 3,
                shadowColor: Colors.black26,
                child: InkWell(
                  onTap: _answered ? null : _playSound,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 22,
                    ),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2E7D32)
                                    .withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _loadingSound
                              ? const Padding(
                                  padding: EdgeInsets.all(26),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Icon(
                                  Icons.volume_up_rounded,
                                  color: Colors.white,
                                  size: 44,
                                ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _answered
                              ? 'Era el ${_correct.name}'
                              : 'Toca para escuchar',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Feedback
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _answered
                    ? _FeedbackBanner(
                        key: ValueKey(_wasCorrect),
                        correct: _wasCorrect,
                        animalName: _correct.name,
                      )
                    : const SizedBox(height: 56, key: ValueKey('empty')),
              ),
              const SizedBox(height: 8),
              // 3 opciones
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 520;
                    if (isWide) {
                      return Row(
                        children: [
                          for (var i = 0; i < _options.length; i++) ...[
                            if (i > 0) const SizedBox(width: 12),
                            Expanded(child: _optionCard(_options[i])),
                          ],
                        ],
                      );
                    }
                    return Column(
                      children: [
                        for (var i = 0; i < _options.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12),
                          Expanded(child: _optionCard(_options[i])),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionCard(Animal animal) {
    final selected = _selectedId == animal.id;
    final isCorrectOption = animal.id == _correct.id;

    Color borderColor = Colors.transparent;
    Color? overlay;
    double scale = 1;

    if (_answered) {
      if (isCorrectOption) {
        borderColor = const Color(0xFF2E7D32);
        overlay = const Color(0xFFC8E6C9).withValues(alpha: 0.55);
        scale = 1.02;
      } else if (selected) {
        borderColor = const Color(0xFFC62828);
        overlay = const Color(0xFFFFCDD2).withValues(alpha: 0.55);
      } else {
        overlay = Colors.black.withValues(alpha: 0.06);
      }
    }

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: animal.color,
        borderRadius: BorderRadius.circular(20),
        elevation: selected || (_answered && isCorrectOption) ? 6 : 2,
        child: InkWell(
          onTap: _answered ? null : () => _onSelect(animal),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: borderColor == Colors.transparent ? 0 : 4,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (overlay != null)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: overlay,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(animal.emoji, style: const TextStyle(fontSize: 56)),
                      const SizedBox(height: 8),
                      Text(
                        animal.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF212121),
                        ),
                      ),
                      if (_answered && isCorrectOption) ...[
                        const SizedBox(height: 6),
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF2E7D32),
                          size: 28,
                        ),
                      ],
                      if (_answered && selected && !isCorrectOption) ...[
                        const SizedBox(height: 6),
                        const Icon(
                          Icons.cancel_rounded,
                          color: Color(0xFFC62828),
                          size: 28,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  final bool correct;
  final String animalName;

  const _FeedbackBanner({
    super.key,
    required this.correct,
    required this.animalName,
  });

  @override
  Widget build(BuildContext context) {
    final bg = correct ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    final text = correct
        ? '¡Felicidades! Era el $animalName 🎉'
        : 'Mejor suerte la próxima 💪';

    return Container(
      width: double.infinity,
      height: 56,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: bg.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
    );
  }
}
