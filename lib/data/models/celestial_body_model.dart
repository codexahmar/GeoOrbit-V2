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

  CelestialBodyModel({
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

  static final List<CelestialBodyModel> allBodies = [
    // 1. Sun
    CelestialBodyModel(
      id: 'sun',
      name: 'The Sun',
      type: 'Star (Yellow Dwarf)',
      texturePath: 'assets/2k_sun.jpg',
      description: 'The central star of our solar system, containing 99.86% of all mass in the system and driving solar energy, weather, and life.',
      glowColor: AppColors.sunGlow,
      glowIntensity: 32.0,
      themeColor: AppColors.neonGold,
      diameter: '1,392,700 km',
      distanceFromSun: '0 km (Center)',
      orbitalPeriod: '230 Million Years',
      orbitalVelocity: '220 km/s',
      dayLength: '27 Earth Days',
      surfaceTemp: '5,500°C (Core 15M°C)',
      gravity: '274.0 m/s²',
      moonsCount: '8 Planets',
      funFact: 'About 1.3 million Earths could fit inside the Sun.',
      atmosphere: {'Hydrogen (H)': '73.5%', 'Helium (He)': '24.9%', 'Oxygen (O)': '0.8%', 'Carbon (C)': '0.3%'},
    ),

    // 2. Mercury
    CelestialBodyModel(
      id: 'mercury',
      name: 'Mercury',
      type: 'Terrestrial Planet',
      texturePath: 'assets/2k_mercury.jpg',
      description: 'The smallest and closest planet to the Sun. It has a heavily cratered rocky surface with extreme temperature fluctuations.',
      glowColor: AppColors.mercuryGlow,
      glowIntensity: 10.0,
      themeColor: AppColors.mercuryGlow,
      diameter: '4,879 km',
      distanceFromSun: '57.9M km (0.39 AU)',
      orbitalPeriod: '88 Days',
      orbitalVelocity: '47.36 km/s',
      dayLength: '176 Earth Days',
      surfaceTemp: '-180°C to +430°C',
      gravity: '3.70 m/s²',
      moonsCount: '0',
      funFact: 'Mercury experiences the greatest temperature swings in the solar system, spanning over 600°C.',
      atmosphere: {'Oxygen (O)': '42%', 'Sodium (Na)': '29%', 'Hydrogen (H)': '22%', 'Helium (He)': '6%'},
    ),

    // 3. Venus
    CelestialBodyModel(
      id: 'venus',
      name: 'Venus',
      type: 'Terrestrial Planet',
      texturePath: 'assets/2k_venus_surface.jpg',
      description: 'The hottest planet in the solar system due to a thick greenhouse atmosphere that traps solar heat beneath sulfuric clouds.',
      glowColor: AppColors.venusGlow,
      glowIntensity: 18.0,
      themeColor: AppColors.venusGlow,
      diameter: '12,104 km',
      distanceFromSun: '108.2M km (0.72 AU)',
      orbitalPeriod: '225 Days',
      orbitalVelocity: '35.02 km/s',
      dayLength: '243 Earth Days (Retrograde)',
      surfaceTemp: '465°C',
      gravity: '8.87 m/s²',
      moonsCount: '0',
      funFact: 'Venus rotates backwards compared to most planets, with the Sun rising in the west and setting in the east.',
      atmosphere: {'Carbon Dioxide (CO₂)': '96.5%', 'Nitrogen (N₂)': '3.5%', 'Sulfur Dioxide': '0.015%'},
    ),

    // 4. Earth
    CelestialBodyModel(
      id: 'earth',
      name: 'Earth',
      type: 'Terrestrial Planet',
      texturePath: 'assets/2k_earth-day.jpg',
      description: 'Our home world, the only known planet in the universe with liquid water oceans, a protective atmosphere, and thriving life.',
      glowColor: AppColors.earthGlow,
      glowIntensity: 18.0,
      themeColor: AppColors.earthGlow,
      diameter: '12,742 km',
      distanceFromSun: '149.6M km (1.0 AU)',
      orbitalPeriod: '365.25 Days',
      orbitalVelocity: '29.78 km/s',
      dayLength: '24 Hours',
      surfaceTemp: '15°C (Average)',
      gravity: '9.807 m/s²',
      moonsCount: '1 (The Moon)',
      funFact: 'Over 71% of Earth’s surface is covered by water, making it a vibrant blue oasis in space.',
      atmosphere: {'Nitrogen (N₂)': '78.08%', 'Oxygen (O₂)': '20.95%', 'Argon (Ar)': '0.93%', 'Carbon Dioxide': '0.04%'},
    ),

    // 5. Moon
    CelestialBodyModel(
      id: 'moon',
      name: 'The Moon',
      type: 'Natural Satellite',
      texturePath: 'assets/2k_moon.jpg',
      description: 'Earth’s gravitationally locked moon that stabilizes Earth’s axial tilt, generates ocean tides, and lights up the night sky.',
      glowColor: AppColors.moonGlow,
      glowIntensity: 12.0,
      themeColor: AppColors.moonGlow,
      diameter: '3,474.8 km',
      distanceFromSun: '149.6M km',
      orbitalPeriod: '27.3 Days',
      orbitalVelocity: '1.02 km/s',
      dayLength: '27.3 Earth Days',
      surfaceTemp: '-130°C to +120°C',
      gravity: '1.62 m/s²',
      moonsCount: '0',
      funFact: 'Due to lack of wind and atmosphere, astronaut footprints on the Moon remain preserved for millions of years.',
      atmosphere: {'Helium (He)': '33%', 'Neon (Ne)': '33%', 'Hydrogen (H)': '20%', 'Argon (Ar)': '14%'},
    ),

    // 6. Mars
    CelestialBodyModel(
      id: 'mars',
      name: 'Mars',
      type: 'Terrestrial Planet',
      texturePath: 'assets/2k_mars.jpg',
      description: 'The Red Planet, featuring iron-rich red soil, the solar system’s largest volcano (Olympus Mons), and deep canyon networks.',
      glowColor: AppColors.marsGlow,
      glowIntensity: 16.0,
      themeColor: AppColors.neonCrimson,
      diameter: '6,779 km',
      distanceFromSun: '227.9M km (1.52 AU)',
      orbitalPeriod: '687 Days',
      orbitalVelocity: '24.07 km/s',
      dayLength: '24h 37m',
      surfaceTemp: '-63°C',
      gravity: '3.721 m/s²',
      moonsCount: '2 (Phobos, Deimos)',
      funFact: 'Olympus Mons on Mars is three times taller than Mount Everest and the largest volcano in the solar system.',
      atmosphere: {'Carbon Dioxide (CO₂)': '95.3%', 'Nitrogen (N₂)': '2.6%', 'Argon (Ar)': '1.9%'},
    ),

    // 7. Jupiter
    CelestialBodyModel(
      id: 'jupiter',
      name: 'Jupiter',
      type: 'Gas Giant',
      texturePath: 'assets/2k_jupiter.jpg',
      description: 'The largest planet in our solar system, with swirling cloud bands, dynamic radiation belts, and the iconic centuries-old Great Red Spot.',
      glowColor: AppColors.jupiterGlow,
      glowIntensity: 22.0,
      themeColor: AppColors.neonAmber,
      diameter: '139,820 km',
      distanceFromSun: '778.5M km (5.20 AU)',
      orbitalPeriod: '11.86 Years',
      orbitalVelocity: '13.07 km/s',
      dayLength: '9h 55m',
      surfaceTemp: '-110°C',
      gravity: '24.79 m/s²',
      moonsCount: '95 Moons',
      funFact: 'Jupiter has a storm called the Great Red Spot that is wider than the entire planet Earth.',
      atmosphere: {'Hydrogen (H₂)': '89.8%', 'Helium (He)': '10.2%', 'Methane (CH₄)': '0.3%'},
    ),

    // 8. Saturn
    CelestialBodyModel(
      id: 'saturn',
      name: 'Saturn',
      type: 'Gas Giant',
      texturePath: 'assets/2k_saturn.jpg',
      description: 'The jewel of the solar system, surrounded by a breathtaking system of concentric icy rings and dozens of icy moons.',
      glowColor: AppColors.saturnGlow,
      glowIntensity: 20.0,
      themeColor: AppColors.saturnGlow,
      diameter: '116,460 km',
      distanceFromSun: '1.43B km (9.58 AU)',
      orbitalPeriod: '29.45 Years',
      orbitalVelocity: '9.68 km/s',
      dayLength: '10h 33m',
      surfaceTemp: '-140°C',
      gravity: '10.44 m/s²',
      moonsCount: '146 Moons',
      funFact: 'Saturn is the only planet in the solar system that is less dense than water—it would float in a giant bathtub!',
      atmosphere: {'Hydrogen (H₂)': '96.3%', 'Helium (He)': '3.25%', 'Methane (CH₄)': '0.45%'},
    ),

    // 9. Uranus
    CelestialBodyModel(
      id: 'uranus',
      name: 'Uranus',
      type: 'Ice Giant',
      texturePath: 'assets/2k_uranus.jpg',
      description: 'A pale cyan ice giant with a unique 98-degree axial tilt that causes it to rotate sideways like a rolling ball.',
      glowColor: AppColors.uranusGlow,
      glowIntensity: 18.0,
      themeColor: AppColors.uranusGlow,
      diameter: '50,724 km',
      distanceFromSun: '2.87B km (19.2 AU)',
      orbitalPeriod: '84 Years',
      orbitalVelocity: '6.80 km/s',
      dayLength: '17h 14m',
      surfaceTemp: '-195°C',
      gravity: '8.69 m/s²',
      moonsCount: '28 Moons',
      funFact: 'Uranus rotates almost completely on its side, meaning each pole gets 42 years of continuous sunlight then 42 years of night.',
      atmosphere: {'Hydrogen (H₂)': '82.5%', 'Helium (He)': '15.2%', 'Methane (CH₄)': '2.3%'},
    ),

    // 10. Neptune
    CelestialBodyModel(
      id: 'neptune',
      name: 'Neptune',
      type: 'Ice Giant',
      texturePath: 'assets/2k_neptune.jpg',
      description: 'The outermost major planet, an intense cobalt-blue world with supersonic winds reaching over 2,100 km/h.',
      glowColor: AppColors.neptuneGlow,
      glowIntensity: 20.0,
      themeColor: AppColors.neptuneGlow,
      diameter: '49,244 km',
      distanceFromSun: '4.50B km (30.1 AU)',
      orbitalPeriod: '164.8 Years',
      orbitalVelocity: '5.43 km/s',
      dayLength: '16h 06m',
      surfaceTemp: '-200°C',
      gravity: '11.15 m/s²',
      moonsCount: '16 Moons',
      funFact: 'Neptune experiences the fastest recorded wind speeds anywhere in the solar system, exceeding supersonic jet speeds.',
      atmosphere: {'Hydrogen (H₂)': '80.0%', 'Helium (He)': '19.0%', 'Methane (CH₄)': '1.5%'},
    ),
  ];
}