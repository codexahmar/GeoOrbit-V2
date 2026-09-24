import 'package:flutter_test/flutter_test.dart';
import 'package:solaris_solar_system/presentation/providers/globe_provider.dart';
import 'package:solaris_solar_system/data/models/celestial_body_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GlobeProvider Tests', () {
    late GlobeProvider provider;

    setUp(() {
      provider = GlobeProvider();
    });

    test('initial state defaults to Earth with 10 total bodies', () {
      expect(provider.selectedBody.id, equals('earth'));
      expect(provider.allBodies.length, equals(10));
      expect(provider.isInitialized, isFalse);
    });

    test('selecting a celestial body updates selectedBody', () {
      final mars = CelestialBodyModel.allBodies.firstWhere((b) => b.id == 'mars');
      provider.initialize();
      provider.selectCelestialBody(mars);
      expect(provider.selectedBody.id, equals('mars'));
      expect(provider.selectedBody.name, equals('Mars'));
    });
  });
}
