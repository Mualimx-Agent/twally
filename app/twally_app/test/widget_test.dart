import 'package:flutter_test/flutter_test.dart';

import 'package:twally_app/main.dart';

void main() {
  testWidgets('Twally app loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TawaliApp());
    expect(find.text('توالّي'), findsWidgets);
  });
}