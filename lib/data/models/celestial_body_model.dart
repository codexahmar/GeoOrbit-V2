import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CelestialBodyModel {
  final String id;
  final String name;
  final String type;
  final String texturePath;
  final String description;
  final Color? glowColor;
  final double? glowIntensity;
  final Color themeColor;
  final String diameter;
  final String distanceFromSun;
  final String orbitalPeriod;
  final String orbitalVelocity;
  final String dayLength;
  final String surfaceTemp;
  final String gravity;
  final String moonsCount;
  final String funFact;
  final Map<String, String> atmosphere;

  const CelestialBodyModel({
    required this.id,
    required this.name,
    required this.type,
    required this.texturePath,
    required this.description,
    this.glowColor,
    this.glowIntensity,
    required this.themeColor,
    required this.diameter,
    required this.distanceFromSun,
    required this.orbitalPeriod,
    required this.orbitalVelocity,
    required this.dayLength,
    required this.surfaceTemp,
    required this.gravity,
    required this.moonsCount,
    required this.funFact,
    required this.atmosphere,
  });

  bool get hasGlow => glowColor != null && glowIntensity != null;

  static const List<CelestialBodyModel> allBodies = [
    // 1. Sun
    CelestialBodyModel(
      id: 'sun',
      name: 'The Sun',
      type: 'Star (Yellow Dwarf)',
      texturePath: 'assets/2k_sun.jpg',
      description: 'The central star of our solar system, containing 99.86% of all mass in the system. Its nuclear fusion engine provides the light and heat sustaining all planetary dynamics.',
      glowColor: AppColors.sunGlow,
      glowIntensity: 30.0,
      themeColor: AppColors.neonGold,
      diameter: '1,392,700 km',
      distanceFromSun: '0 km (Center)',
      orbitalPeriod: '230 Million Yrs',
      orbitalVelocity: '220 km/s',
      dayLength: '27 Earth Days',
      surfaceTemp: '5,500°C (Core 15M°C)',
      gravity: '274.0 m/s²',
      moonsCount: '8 Major Planets',
      funFact: 'About 1.3 million Earths could fit inside the Sun, and light from its core takes over 100,000 years to reach its surface.',
      atmosphere: {'Hydrogen (H₂)': '73.5%', 'Helium (He)': '24.9%', 'Oxygen (O)': '0.8%', 'Carbon (C)': '0.3%'},
    ),

    // 2. Mercury
    CelestialBodyModel(
      id: 'mercury',
      name: 'Mercury',
      type: 'Terrestrial Planet',
      texturePath: 'assets/2k_mercury.jpg',
      description: 'The smallest and innermost planet in the solar system. Having virtually no atmosphere to trap heat, it experiences dramatic temperature swings between day and night.',
      glowColor: AppColors.mercuryGlow,
      glowIntensity: 10.0,
      themeColor: AppColors.mercuryGlow,
      diameter: '4,879 km',
      distanceFromSun: '57.9M km (0.39 AU)',
      orbitalPeriod: '88 Earth Days',
      orbitalVelocity: '47.36 km/s',
      dayLength: '176 Earth Days',
      surfaceTemp: '-180°C to +430°C',
      gravity: '3.70 m/s²',
      moonsCount: '0 Moons',
      funFact: 'Mercury is slowly shrinking over billions of years as its huge metallic iron core cools and solidifies.',
      atmosphere: {'Oxygen (O)': '42%', 'Sodium (Na)': '29%', 'Hydrogen (H)': '22%', 'Helium (He)': '6%'},
    ),

    // 3. Venus
    CelestialBodyModel(
      id: 'venus',
      name: 'Venus',
      type: 'Terrestrial Planet',
      texturePath: 'assets/2k_venus_surface.jpg',
      description: 'Earth’s twin in size and mass, shrouded in reflective sulfuric clouds and a crushing carbon dioxide atmosphere that creates a runaway greenhouse effect.',
      glowColor: AppColors.venusGlow,
      glowIntensity: 18.0,
      themeColor: AppColors.venusGlow,
      diameter: '12,104 km',
      distanceFromSun: '108.2M km (0.72 AU)',
      orbitalPeriod: '225 Earth Days',
      orbitalVelocity: '35.02 km/s',
      dayLength: '243 Earth Days (Retrograde)',
      surfaceTemp: '465°C (Hottest)',
      gravity: '8.87 m/s²',
      moonsCount: '0 Moons',
      funFact: 'Venus rotates in retrograde (clockwise). If you stood on Venus, the Sun would rise in the west and set in the east.',
      atmosphere: {'Carbon Dioxide (CO₂)': '96.5%', 'Nitrogen (N₂)': '3.5%', 'Sulfur Dioxide': '0.015%'},
    ),

    // 4. Earth
    CelestialBodyModel(
      id: 'earth',
      name: 'Earth',
      type: 'Terrestrial Planet',
      texturePath: 'assets/2k_earth-day.jpg',
      description: 'The third planet from the Sun and the only known haven for life in the universe, blessed with liquid water oceans, a dynamic magnetosphere, and a breathable atmosphere.',
      glowColor: AppColors.earthGlow,
      glowIntensity: 18.0,
      themeColor: AppColors.earthGlow,
      diameter: '12,742 km',
      distanceFromSun: '149.6M km (1.00 AU)',
      orbitalPeriod: '365.25 Days',
      orbitalVelocity: '29.78 km/s',
      dayLength: '24 Hours',
      surfaceTemp: '15°C Average',
      gravity: '9.807 m/s²',
      moonsCount: '1 Moon',
      funFact: 'Over 71% of Earth’s surface is covered by liquid oceans, holding 96.5% of all water on the globe.',
      atmosphere: {'Nitrogen (N₂)': '78.08%', 'Oxygen (O₂)': '20.95%', 'Argon (Ar)': '0.93%', 'Carbon Dioxide': '0.04%'},
    ),

    // 5. Moon
    CelestialBodyModel(
      id: 'moon',
      name: 'The Moon',
      type: 'Natural Satellite',
      texturePath: 'assets/2k_moon.jpg',
      description: 'Earth’s only natural satellite, orbiting at an average distance of 384,400 km. It creates ocean tides and stabilizes Earth’s 23.5-degree axial tilt.',
      glowColor: AppColors.moonGlow,
      glowIntensity: 12.0,
      themeColor: AppColors.moonGlow,
      diameter: '3,474.8 km',
      distanceFromSun: '384,400 km from Earth',
      orbitalPeriod: '27.3 Earth Days',
      orbitalVelocity: '1.02 km/s',
      dayLength: '29.5 Earth Days',
      surfaceTemp: '-130°C to +120°C',
      gravity: '1.62 m/s²',
      moonsCount: '0 (Orbits Earth)',
      funFact: 'Because the Moon has no atmosphere or liquid water, astronaut bootprints and rover tracks will remain undisturbed for millions of years.',
      atmosphere: {'Helium (He)': '33%', 'Neon (Ne)': '33%', 'Hydrogen (H)': '20%', 'Argon (Ar)': '14%'},
    ),

    // 6. Mars
    CelestialBodyModel(
      id: 'mars',
      name: 'Mars',
      type: 'Terrestrial Planet',
      texturePath: 'assets/2k_mars.jpg',
      description: 'The Red Planet, renowned for iron-oxide rusty dust, polar ice caps, dried ancient river valleys, and the monumental Olympus Mons shield volcano.',
      glowColor: AppColors.marsGlow,
      glowIntensity: 16.0,
      themeColor: AppColors.neonCrimson,
      diameter: '6,779 km',
      distanceFromSun: '227.9M km (1.52 AU)',
      orbitalPeriod: '687 Earth Days',
      orbitalVelocity: '24.07 km/s',
      dayLength: '24h 37m',
      surfaceTemp: '-63°C Average',
      gravity: '3.721 m/s²',
      moonsCount: '2 (Phobos, Deimos)',
      funFact: 'Olympus Mons on Mars is 21.9 km tall—nearly three times the height of Mount Everest above sea level.',
      atmosphere: {'Carbon Dioxide (CO₂)': '95.3%', 'Nitrogen (N₂)': '2.6%', 'Argon (Ar)': '1.9%'},
    ),

    // 7. Jupiter
    CelestialBodyModel(
      id: 'jupiter',
      name: 'Jupiter',
      type: 'Gas Giant',
      texturePath: 'assets/2k_jupiter.jpg',
      description: 'The undisputed king of planets, with more than twice the mass of all other planets combined. It features dramatic atmospheric bands and a protective magnetosphere.',
      glowColor: AppColors.jupiterGlow,
      glowIntensity: 22.0,
      themeColor: AppColors.neonAmber,
      diameter: '139,820 km',
      distanceFromSun: '778.5M km (5.20 AU)',
      orbitalPeriod: '11.86 Earth Years',
      orbitalVelocity: '13.07 km/s',
      dayLength: '9h 55m (Fastest)',
      surfaceTemp: '-110°C',
      gravity: '24.79 m/s²',
      moonsCount: '95 Known Moons',
      funFact: 'Jupiter’s Great Red Spot is a persistent high-pressure storm larger than Earth that has raged continuously for over 350 years.',
      atmosphere: {'Hydrogen (H₂)': '89.8%', 'Helium (He)': '10.2%', 'Methane (CH₄)': '0.3%'},
    ),

    // 8. Saturn
    CelestialBodyModel(
      id: 'saturn',
      name: 'Saturn',
      type: 'Gas Giant',
      texturePath: 'assets/2k_saturn.jpg',
      description: 'The crown jewel of the solar system, surrounded by spectacular thousands of ringlets composed of water ice, rock shards, and dust particles.',
      glowColor: AppColors.saturnGlow,
      glowIntensity: 20.0,
      themeColor: AppColors.saturnGlow,
      diameter: '116,460 km',
      distanceFromSun: '1.43B km (9.58 AU)',
      orbitalPeriod: '29.45 Earth Years',
      orbitalVelocity: '9.68 km/s',
      dayLength: '10h 33m',
      surfaceTemp: '-140°C',
      gravity: '10.44 m/s²',
      moonsCount: '146 Known Moons',
      funFact: 'Saturn is the least dense planet in the solar system (0.687 g/cm³)—it is less dense than water and would float in a giant ocean!',
      atmosphere: {'Hydrogen (H₂)': '96.3%', 'Helium (He)': '3.25%', 'Methane (CH₄)': '0.45%'},
    ),

    // 9. Uranus
    CelestialBodyModel(
      id: 'uranus',
      name: 'Uranus',
      type: 'Ice Giant',
      texturePath: 'assets/2k_uranus.jpg',
      description: 'An ethereal pale-cyan ice giant with methane clouds. It has a unique 98-degree axial tilt, causing it to effectively rotate on its side as it orbits.',
      glowColor: AppColors.uranusGlow,
      glowIntensity: 18.0,
      themeColor: AppColors.uranusGlow,
      diameter: '50,724 km',
      distanceFromSun: '2.87B km (19.2 AU)',
      orbitalPeriod: '84.0 Earth Years',
      orbitalVelocity: '6.80 km/s',
      dayLength: '17h 14m',
      surfaceTemp: '-195°C',
      gravity: '8.69 m/s²',
      moonsCount: '28 Known Moons',
      funFact: 'Uranus rolls like a ball around the Sun. Each of its poles gets 42 years of continuous sunlight, followed by 42 years of complete darkness.',
      atmosphere: {'Hydrogen (H₂)': '82.5%', 'Helium (He)': '15.2%', 'Methane (CH₄)': '2.3%'},
    ),

    // 10. Neptune
    CelestialBodyModel(
      id: 'neptune',
      name: 'Neptune',
      type: 'Ice Giant',
      texturePath: 'assets/2k_neptune.jpg',
      description: 'The outermost major planet in our solar system, an intense vivid blue world of supersonic methane storms and freezing ammonia oceans.',
      glowColor: AppColors.neptuneGlow,
      glowIntensity: 20.0,
      themeColor: AppColors.neptuneGlow,
      diameter: '49,244 km',
      distanceFromSun: '4.50B km (30.1 AU)',
      orbitalPeriod: '164.8 Earth Years',
      orbitalVelocity: '5.43 km/s',
      dayLength: '16h 06m',
      surfaceTemp: '-200°C',
      gravity: '11.15 m/s²',
      moonsCount: '16 Known Moons',
      funFact: 'Neptune features the fastest winds recorded anywhere in the solar system, reaching supersonic speeds beyond 2,100 km/h (1,300 mph).',
      atmosphere: {'Hydrogen (H₂)': '80.0%', 'Helium (He)': '19.0%', 'Methane (CH₄)': '1.5%'},
    ),
  ];
}