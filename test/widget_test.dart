import 'package:cosmic_globe/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Cosmic Orbit App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CosmicOrbitApp());
    expect(find.byType(CosmicOrbitApp), findsOneWidget);
  });
}
