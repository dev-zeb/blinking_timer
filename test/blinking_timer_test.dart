import 'package:blinking_timer/src/blinking_controller.dart';
import 'package:blinking_timer/src/blinking_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Initial render with default values',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlinkingTimer(
            duration: const Duration(seconds: 10),
            onTimeUpThreshold: () {},
          ),
        ),
      ),
    );

    expect(find.text('00:10'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Timer counts down correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlinkingTimer(
            duration: const Duration(seconds: 3),
            onTimeUpThreshold: () {},
          ),
        ),
      ),
    );

    // Initial state
    expect(find.text('00:03'), findsOneWidget);

    // After 1 second
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:02'), findsOneWidget);

    // After 2 more seconds
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Time Up!'), findsOneWidget);
  });

  testWidgets('Controller methods work', (WidgetTester tester) async {
    final controller = BlinkingTimerController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlinkingTimer(
            duration: const Duration(seconds: 10),
            controller: controller,
            onTimeUpThreshold: () {},
          ),
        ),
      ),
    );

    // Initial state
    expect(find.text('00:10'), findsOneWidget);

    // Pause and verify timer stops
    controller.pause();
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('00:10'), findsOneWidget);

    // Resume and verify it continues
    controller.resume();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:09'), findsOneWidget);

    // Restart and verify
    controller.restart(const Duration(seconds: 5));
    await tester.pump();
    expect(find.text('00:05'), findsOneWidget);
  });

  testWidgets('Blinking thresholds trigger', (WidgetTester tester) async {
    bool warningTriggered = false;
    bool criticalTriggered = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlinkingTimer(
            duration: const Duration(seconds: 10),
            slowBlinkingThreshold: 0.5,
            // 5 seconds
            fastBlinkingThreshold: 0.2,
            // 2 seconds
            onWarningThreshold: () => warningTriggered = true,
            onCriticalThreshold: () => criticalTriggered = true,
            onTimeUpThreshold: () {},
          ),
        ),
      ),
    );

    // Initial state
    expect(warningTriggered, false);
    expect(criticalTriggered, false);

    // Reach warning threshold
    await tester.pump(const Duration(seconds: 6));
    expect(warningTriggered, true);
    expect(criticalTriggered, false);

    // Reach critical threshold
    await tester.pump(const Duration(seconds: 4));
    expect(criticalTriggered, true);
  });

  testWidgets('Custom UI renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlinkingTimer(
            duration: const Duration(seconds: 5),
            customTimerUI: (timeText, color, progress, shouldBlink, isBlinking) {
              return AnimatedOpacity(
                opacity: isBlinking ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Text(timeText, style: TextStyle(color: color)),
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(Container), findsOneWidget);
    expect(find.text('00:05'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

// test/blinking_timer_test.dart
  testWidgets('Controller methods affect timer state',
      (WidgetTester tester) async {
    final controller = BlinkingTimerController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlinkingTimer(
            duration: const Duration(seconds: 10),
            controller: controller,
            onTimeUpThreshold: () {},
          ),
        ),
      ),
    );

    // Verify timer is running by checking initial state
    expect(find.text('00:10'), findsOneWidget);

    // Test pause functionality
    controller.pause();
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('00:10'), findsOneWidget); // Time shouldn't change

    // Test resume
    controller.resume();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:09'), findsOneWidget); // Time should decrement

    // Test restart
    controller.restart(const Duration(seconds: 5));
    await tester.pump();
    expect(find.text('00:05'), findsOneWidget);
  });

  testWidgets('Controller cleans up on dispose', (WidgetTester tester) async {
    final controller = BlinkingTimerController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlinkingTimer(
            duration: const Duration(seconds: 10),
            controller: controller,
            onTimeUpThreshold: () {},
          ),
        ),
      ),
    );

    // Verify controller is working
    controller.pause();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:10'), findsOneWidget);

    // Dispose and verify no errors
    await tester.pumpWidget(Container());
    controller.pause(); // Should safely do nothing
  });
}
