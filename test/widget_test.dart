import 'package:flutter_test/flutter_test.dart';
import 'package:projekt_unbarmherzigkeit/src/services/language_service.dart';
import 'package:projekt_unbarmherzigkeit/src/data/mockdatabase_repository.dart';
import 'package:projekt_unbarmherzigkeit/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        languageService: LanguageService(),
        repository: MockDatabaseRepository(),
      ),
    );

    // Verify that the app starts without crashing
    expect(find.byType(MyApp), findsOneWidget);
  });
}
