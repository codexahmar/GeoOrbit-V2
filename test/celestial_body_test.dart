import 'package:flutter_test/flutter_test.dart';
import 'package:solaris_solar_system/data/models/celestial_body_model.dart';

void main() {
  group('CelestialBodyModel Astronomical Data Verification', () {
    test('contains all 10 essential solar system celestial bodies in order', () {
      const bodies = CelestialBodyModel.allBodies;
      expect(bodies.length, equals(10));

      const expectedIds = [
        'sun',
        'mercury',
        'venus',
        'earth',
        'moon',
        'mars',
        'jupiter',
        'saturn',
        'uranus',
        'neptune',
      ];

      for (int i = 0; i < expectedIds.length; i++) {
        expect(bodies[i].id, equals(expectedIds[i]));
      }
    });

    test('all bodies have non-empty required facts and educational data', () {
      for (final body in CelestialBodyModel.allBodies) {
        expect(body.id.isNotEmpty, isTrue);
        expect(body.name.isNotEmpty, isTrue);
        expect(body.type.isNotEmpty, isTrue);
        expect(body.texturePath.isNotEmpty, isTrue);
        expect(body.description.isNotEmpty, isTrue);
        expect(body.diameter.isNotEmpty, isTrue);
        expect(body.distanceFromSun.isNotEmpty, isTrue);
        expect(body.orbitalPeriod.isNotEmpty, isTrue);
        expect(body.orbitalVelocity.isNotEmpty, isTrue);
        expect(body.dayLength.isNotEmpty, isTrue);
        expect(body.surfaceTemp.isNotEmpty, isTrue);
        expect(body.gravity.isNotEmpty, isTrue);
        expect(body.moonsCount.isNotEmpty, isTrue);
        expect(body.funFact.isNotEmpty, isTrue);
        expect(body.atmosphere.isNotEmpty, isTrue);
      }
    });

    test('verifies accurate satellite & moon counts for major planets', () {
      final jupiter = CelestialBodyModel.allBodies.firstWhere((b) => b.id == 'jupiter');
      expect(jupiter.moonsCount, contains('95'));

      final saturn = CelestialBodyModel.allBodies.firstWhere((b) => b.id == 'saturn');
      expect(saturn.moonsCount, contains('146'));

      final uranus = CelestialBodyModel.allBodies.firstWhere((b) => b.id == 'uranus');
      expect(uranus.moonsCount, contains('28'));

      final neptune = CelestialBodyModel.allBodies.firstWhere((b) => b.id == 'neptune');
      expect(neptune.moonsCount, contains('16'));

      final mars = CelestialBodyModel.allBodies.firstWhere((b) => b.id == 'mars');
      expect(mars.moonsCount, contains('2'));

      final earth = CelestialBodyModel.allBodies.firstWhere((b) => b.id == 'earth');
      expect(earth.moonsCount, contains('1'));
    });
  });
}
