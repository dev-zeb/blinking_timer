// Copyright (c) 2025, Sufi Aurangzeb Hossain.
// Licensed under the BSD 3-Clause License - see LICENSE file for details.

import 'package:blinking_timer/blinking_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlinkingTimerController Tests', () {
    test('Controller can attach and detach state', () {
      final controller = BlinkingTimerController();
      final mockState = _MockTimerStateController();

      controller.attach(mockState);

      controller.pause();
      expect(mockState.pauseCalled, isTrue);

      controller.dispose();
      // After dispose, methods should not call through to state
      controller.resume();
      expect(mockState.resumeCalled, isFalse);
    });

    test('Controller methods work when attached', () {
      final controller = BlinkingTimerController();
      final mockState = _MockTimerStateController();

      controller.attach(mockState);

      controller.pause();
      expect(mockState.pauseCalled, isTrue);

      controller.resume();
      expect(mockState.resumeCalled, isTrue);

      controller.restart(const Duration(seconds: 5));
      expect(mockState.restartCalled, isTrue);
      expect(mockState.restartDuration, const Duration(seconds: 5));
    });

    test('Controller methods do nothing when not attached', () {
      final controller = BlinkingTimerController();

      // Should not throw exceptions when not attached
      expect(() => controller.pause(), returnsNormally);
      expect(() => controller.resume(), returnsNormally);
      expect(() => controller.restart(), returnsNormally);
    });

    test('Controller handles dispose correctly', () {
      final controller = BlinkingTimerController();
      final mockState = _MockTimerStateController();

      controller.attach(mockState);
      controller.dispose();

      // After dispose, methods should not throw or call through
      expect(() => controller.pause(), returnsNormally);
      expect(() => controller.resume(), returnsNormally);
      expect(() => controller.restart(), returnsNormally);

      // Verify no calls were made to the state after dispose
      expect(mockState.pauseCalled, isFalse);
      expect(mockState.resumeCalled, isFalse);
      expect(mockState.restartCalled, isFalse);
    });
  });

  group('BlinkingTimer Widget Tests', () {
    testWidgets('BlinkingTimer renders with default values',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(seconds: 10),
            ),
          ),
        ),
      );

      // Verify the timer text is displayed
      expect(find.text('00:10'), findsOneWidget);

      // Verify progress indicator is shown by default
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('BlinkingTimer shows milliseconds when enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(seconds: 10),
              showMilliseconds: true,
            ),
          ),
        ),
      );

      // Should show format with milliseconds
      expect(find.textContaining(RegExp(r'00:10\.\d{2}')), findsOneWidget);
    });

    testWidgets('Custom UI renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(seconds: 10),
              customTimerUI: (text, color, progress, shouldBlink, isBlinking) {
                return Text('Custom: $text');
              },
            ),
          ),
        ),
      );

      // Look for the Text widget returned by custom UI
      expect(find.text('Custom: 00:10'), findsOneWidget);
    });

    testWidgets('Default UI uses Container wrapper',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(seconds: 10),
            ),
          ),
        ),
      );

      // Default UI should have a Container
      expect(find.byType(Container), findsOneWidget);
      expect(find.text('00:10'), findsOneWidget);
    });

    testWidgets('BlinkingTimer shows time up text when duration ends',
        (WidgetTester tester) async {
      // Use a very short duration for testing
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(milliseconds: 100),
              timeUpText: 'TEST COMPLETE',
            ),
          ),
        ),
      );

      // Wait for timer to complete
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      expect(find.text('TEST COMPLETE'), findsOneWidget);
    });

    testWidgets('BlinkingTimer respects autoStart false',
        (WidgetTester tester) async {
      final controller = BlinkingTimerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(seconds: 10),
              autoStart: false,
              controller: controller,
            ),
          ),
        ),
      );

      // Timer should not start automatically - should show initial time
      expect(find.text('00:10'), findsOneWidget);
    });

    testWidgets('BlinkingTimer controller methods work',
        (WidgetTester tester) async {
      final controller = BlinkingTimerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(seconds: 10),
              controller: controller,
              autoStart: false, // Don't auto-start for this test
            ),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('00:10'), findsOneWidget);

      // Test controller methods don't throw
      expect(() => controller.pause(), returnsNormally);
      expect(() => controller.resume(), returnsNormally);
      expect(() => controller.restart(), returnsNormally);
    });

    testWidgets('BlinkingTimer color transitions work',
        (WidgetTester tester) async {
      // Use specific Color objects instead of MaterialColor to avoid comparison issues
      const Color initialColor = Color(0xFF4CAF50); // Green
      const Color warningColor = Color(0xFFFF9800); // Orange
      const Color criticalColor = Color(0xFFF44336); // Red

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(milliseconds: 500),
              initialColor: initialColor,
              warningColor: warningColor,
              criticalColor: criticalColor,
              slowBlinkingThreshold: 0.6,
              fastBlinkingThreshold: 0.3,
            ),
          ),
        ),
      );

      // Initial color should be initialColor
      final initialText = tester.widget<Text>(find.text('00:00'));
      expect(initialText.style!.color, initialColor);
    });

    testWidgets('BlinkingTimer handles progress display',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(seconds: 10),
              showProgress: false,
            ),
          ),
        ),
      );

      // Progress indicator should not be shown
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('BlinkingTimer custom styling works',
        (WidgetTester tester) async {
      const customStyle = TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.purple,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(seconds: 10),
              textStyle: customStyle,
              backgroundColor: Colors.blue,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      );

      // Verify custom text style
      final textWidget = tester.widget<Text>(find.text('00:10'));
      expect(textWidget.style!.fontSize, 20);
      expect(textWidget.style!.fontWeight, FontWeight.bold);

      // Verify container styling - use more specific finder
      final containerFinder = find.descendant(
        of: find.byType(BlinkingTimer),
        matching: find.byType(Container),
      );
      final container = tester.widget<Container>(containerFinder);
      expect(container.padding, const EdgeInsets.all(16));
    });

    testWidgets('BlinkingTimer callbacks are triggered',
        (WidgetTester tester) async {
      bool warningCalled = false;
      bool criticalCalled = false;
      bool timeUpCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(milliseconds: 300),
              slowBlinkingThreshold: 0.8,
              // High threshold to trigger quickly
              fastBlinkingThreshold: 0.5,
              // High threshold to trigger quickly
              onWarningThreshold: () => warningCalled = true,
              onCriticalThreshold: () => criticalCalled = true,
              onTimeUpThreshold: () => timeUpCalled = true,
            ),
          ),
        ),
      );

      // Wait for thresholds to be reached and timer to complete
      await tester.pumpAndSettle(const Duration(milliseconds: 400));

      // Verify callbacks were called
      expect(warningCalled, isTrue);
      expect(criticalCalled, isTrue);
      expect(timeUpCalled, isTrue);
    });

    testWidgets('BlinkingTimer validates constructor arguments',
        (WidgetTester tester) async {
      // Test invalid duration
      expect(
        () => BlinkingTimer(duration: Duration.zero),
        throwsA(isA<AssertionError>()),
      );

      // Test invalid threshold order
      expect(
        () => BlinkingTimer(
          duration: const Duration(seconds: 10),
          slowBlinkingThreshold: 0.1,
          fastBlinkingThreshold: 0.2,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('BlinkingTimer formats time correctly with hours',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(hours: 1, minutes: 5, seconds: 10),
            ),
          ),
        ),
      );

      expect(find.text('01:05:10'), findsOneWidget);
    });
  });

  group('Integration Tests', () {
    testWidgets('Complete timer lifecycle with controller',
        (WidgetTester tester) async {
      final controller = BlinkingTimerController();
      bool timeUpCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(milliseconds: 150),
              controller: controller,
              onTimeUpThreshold: () => timeUpCalled = true,
            ),
          ),
        ),
      );

      // Wait for completion
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      // Verify completion
      expect(timeUpCalled, isTrue);
      expect(find.text('Time Up!'), findsOneWidget);
    });

    testWidgets('Custom UI with blinking effects', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(milliseconds: 500),
              customTimerUI: (text, color, progress, shouldBlink, isBlinking) {
                return Container(
                  width: 100,
                  height: 100,
                  color: isBlinking ? color.withValues(alpha: 0.5) : color,
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            isBlinking ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
              slowBlinkingThreshold: 0.6,
              fastBlinkingThreshold: 0.3,
            ),
          ),
        ),
      );

      // Should render without errors
      expect(find.byType(Container), findsOneWidget);

      // Let some time pass to trigger blinking
      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('Timer can be paused and resumed', (WidgetTester tester) async {
      final controller = BlinkingTimerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(seconds: 10),
              controller: controller,
              autoStart: true,
            ),
          ),
        ),
      );

      // Let timer run for a bit
      await tester.pump(const Duration(milliseconds: 100));

      // Get current time text
      final initialFinder = find.descendant(
        of: find.byType(BlinkingTimer),
        matching: find.byType(Text),
      );
      final initialText = tester.widget<Text>(initialFinder);

      // Pause and wait
      controller.pause();
      await tester.pump(const Duration(seconds: 1));

      // Time should not have changed significantly when paused
      final pausedText = tester.widget<Text>(initialFinder);
      expect(pausedText.data, initialText.data);

      // Resume
      controller.resume();
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('Timer restart works', (WidgetTester tester) async {
      final controller = BlinkingTimerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlinkingTimer(
              duration: const Duration(seconds: 10),
              controller: controller,
              autoStart: false, // Don't auto-start for restart test
            ),
          ),
        ),
      );

      // Should show initial duration
      expect(find.text('00:10'), findsOneWidget);

      // Restart with new duration
      controller.restart(const Duration(seconds: 5));
      await tester.pump();

      // Should show the new duration
      expect(find.text('00:05'), findsOneWidget);
    });
  });
}

class _MockTimerStateController implements TimerStateController {
  bool pauseCalled = false;
  bool resumeCalled = false;
  bool restartCalled = false;
  Duration? restartDuration;

  @override
  void pause() {
    pauseCalled = true;
  }

  @override
  void resume() {
    resumeCalled = true;
  }

  @override
  void restart(Duration? newDuration) {
    restartCalled = true;
    restartDuration = newDuration;
  }
}
