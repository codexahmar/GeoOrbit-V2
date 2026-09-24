import 'package:solaris_solar_system/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Solaris App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SolarisApp());
    expect(find.byType(SolarisApp), findsOneWidget);
  });
}
