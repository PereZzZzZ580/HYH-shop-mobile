import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hyhshopmobile/app/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    dotenv.testLoad(fileInput: 'APP_NAME=HyH Shop Test\n');
  });

  testWidgets('renders main navigator with bottom navigation', (tester) async {
    await tester.pumpWidget(const HyHShopMobileApp());
    await tester.pumpAndSettle();

    final titleFinder = find.byKey(const Key('mainNavigatorTitle'));
    expect(titleFinder, findsOneWidget);
    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Citas'), findsWidgets);
    expect(find.text('Servicios'), findsWidgets);

    final titleWidget = tester.widget<Text>(titleFinder);
    expect(titleWidget.data, 'HyH Shop');
  });

  testWidgets('changes app bar title when selecting Servicios tab', (tester) async {
    await tester.pumpWidget(const HyHShopMobileApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Servicios').last);
    await tester.pumpAndSettle();

    final titleWidget = tester.widget<Text>(find.byKey(const Key('mainNavigatorTitle')));
    expect(titleWidget.data, 'Servicios');
  });
}
