import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the example exposes the file and image pickers', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Pick File'), findsOneWidget);
    await tester.tap(find.text('Pick Image'));
    await tester.pumpAndSettle();

    expect(find.text('Choose from camera'), findsOneWidget);
    expect(find.text('Choose from gallery'), findsOneWidget);
  });
}
