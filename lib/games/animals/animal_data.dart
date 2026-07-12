import 'package:flutter/material.dart';

/// Un animal del juego de sonidos.
class Animal {
  final String id;
  final String name;
  final String emoji;
  final String soundAsset;
  final Color color;

  const Animal({
    required this.id,
    required this.name,
    required this.emoji,
    required this.soundAsset,
    required this.color,
  });
}

/// 10 animales con sonido real (assets/sounds/animals/).
class AnimalData {
  static const List<Animal> all = [
    Animal(
      id: 'cat',
      name: 'Gato',
      emoji: '🐱',
      soundAsset: 'assets/sounds/animals/cat.mp3',
      color: Color(0xFFFFB74D),
    ),
    Animal(
      id: 'dog',
      name: 'Perro',
      emoji: '🐶',
      soundAsset: 'assets/sounds/animals/dog.mp3',
      color: Color(0xFF8D6E63),
    ),
    Animal(
      id: 'cow',
      name: 'Vaca',
      emoji: '🐄',
      soundAsset: 'assets/sounds/animals/cow.mp3',
      color: Color(0xFF90CAF9),
    ),
    Animal(
      id: 'pig',
      name: 'Cerdo',
      emoji: '🐷',
      soundAsset: 'assets/sounds/animals/pig.mp3',
      color: Color(0xFFF48FB1),
    ),
    Animal(
      id: 'duck',
      name: 'Pato',
      emoji: '🦆',
      soundAsset: 'assets/sounds/animals/duck.mp3',
      color: Color(0xFFFFF176),
    ),
    Animal(
      id: 'chicken',
      name: 'Pollo',
      emoji: '🐔',
      soundAsset: 'assets/sounds/animals/chicken.mp3',
      color: Color(0xFFFFCC80),
    ),
    Animal(
      id: 'horse',
      name: 'Caballo',
      emoji: '🐴',
      soundAsset: 'assets/sounds/animals/horse.mp3',
      color: Color(0xFFA1887F),
    ),
    Animal(
      id: 'sheep',
      name: 'Oveja',
      emoji: '🐑',
      soundAsset: 'assets/sounds/animals/sheep.mp3',
      color: Color(0xFFE0E0E0),
    ),
    Animal(
      id: 'lion',
      name: 'León',
      emoji: '🦁',
      soundAsset: 'assets/sounds/animals/lion.mp3',
      color: Color(0xFFFFD54F),
    ),
    Animal(
      id: 'elephant',
      name: 'Elefante',
      emoji: '🐘',
      soundAsset: 'assets/sounds/animals/elephant.mp3',
      color: Color(0xFFB0BEC5),
    ),
  ];
}
