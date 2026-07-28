import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('PolicyPalApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PolicyPalApp());
    await tester.pumpAndSettle();
    expect(find.text('PolicyPal'), findsWidgets);
  });
}
