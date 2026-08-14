import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:guc_logistics/core/data/mock/mock_data.dart';
import 'package:guc_logistics/core/theme/guc_theme.dart';
import 'package:guc_logistics/core/widgets/guc_widgets.dart';

void main() {
  test('mock data provides browsable loads and offers', () {
    expect(MockData.loads, isNotEmpty);
    expect(MockData.offers, isNotEmpty);
    expect(MockData.vehicles, isNotEmpty);
  });

  testWidgets('design system badge renders', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: GucTheme.light,
        home: const Scaffold(body: GucBadge(label: 'Verified', tone: GucBadgeTone.success)),
      ),
    );
    expect(find.text('Verified'), findsOneWidget);
  });
}
