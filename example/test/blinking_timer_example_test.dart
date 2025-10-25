// Copyright (c) 2025, Sufi Aurangzeb Hossain.
// Licensed under the BSD 3-Clause License - see LICENSE file for details.

import 'package:blinking_timer/blinking_timer.dart';
import 'package:blinking_timer_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlinkingTimer Example App Tests', () {
    testWidgets('Example app renders all three examples',
        (WidgetTester tester) async {
      /// Build our example app
      await tester.pumpWidget(const BlinkingTimerExample());

      /// Verify all three example sections are present
      expect(find.text('Basic Usage Example'), findsOneWidget);
      expect(find.text('Custom UI Example'), findsOneWidget);
      expect(find.text('Advanced Usage Example'), findsOneWidget);

      /// Verify all timer instances are present
      expect(find.byType(BlinkingTimer), findsNWidgets(3));
    });

    testWidgets('Basic usage example has correct configuration',
        (WidgetTester tester) async {
      await tester.pumpWidget(const BlinkingTimerExample());

      /// Find the basic usage timer and verify its properties
      final basicTimer =
          tester.widgetList<BlinkingTimer>(find.byType(BlinkingTimer)).first;

      expect(basicTimer.duration, const Duration(seconds: 10));
      expect(basicTimer.showMilliseconds, isTrue);
      expect(basicTimer.slowBlinkingThreshold, 0.5);
      expect(basicTimer.fastBlinkingThreshold, 0.3);
    });

    testWidgets('Custom UI example renders circular progress',
        (WidgetTester tester) async {
      await tester.pumpWidget(const BlinkingTimerExample());

      /// The custom UI should contain CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      /// Should contain progress percentage text
      expect(find.textContaining('%'), findsWidgets);
    });

    testWidgets('Advanced usage controller buttons work',
        (WidgetTester tester) async {
      await tester.pumpWidget(const BlinkingTimerExample());

      /// Find all control buttons
      final pauseButton = find.text('Pause');
      final resumeButton = find.text('Resume');
      final restartButton = find.text('Restart Timer');

      /// Verify buttons are present
      expect(pauseButton, findsOneWidget);
      expect(resumeButton, findsOneWidget);
      expect(restartButton, findsOneWidget);

      /// Test button taps (they should not throw exceptions)
      await tester.tap(pauseButton);
      await tester.pump();

      await tester.tap(resumeButton);
      await tester.pump();

      await tester.tap(restartButton);
      await tester.pump();
    });

    testWidgets('Example app maintains state correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const BlinkingTimerExample());

      // Initial build should work
      expect(find.byType(BlinkingTimer), findsNWidgets(3));

      // Trigger a rebuild
      await tester.pumpAndSettle();

      // Should still have all widgets
      expect(find.byType(BlinkingTimer), findsNWidgets(3));
    });
  });
}
