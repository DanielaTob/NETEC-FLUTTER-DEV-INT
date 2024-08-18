import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:testing_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('end-to-end test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
// Verificar que el contador inicial es 0
    expect(find.text('0'), findsOneWidget);
// Presionar el botón de incremento
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
// Verificar que el contador ha incrementado
    expect(find.text('1'), findsOneWidget);
// Presionar el botón de decremento
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();
// Verificar que el contador ha decrementado
    expect(find.text('0'), findsOneWidget);
  });
}