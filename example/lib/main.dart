import 'package:blinking_timer/blinking_timer.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const BlinkingTimerExample());
}

class BlinkingTimerExample extends StatefulWidget {
  const BlinkingTimerExample({super.key});

  @override
  State<BlinkingTimerExample> createState() => _BlinkingTimerExampleState();
}

class _BlinkingTimerExampleState extends State<BlinkingTimerExample> {
  int exampleMinute = 1;
  late final BlinkingTimerController timerController;

  @override
  void initState() {
    super.initState();
    timerController = BlinkingTimerController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blinking Timer Example',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              /// Example 1: Basic Usage
              BlinkingTimer(
                duration: const Duration(seconds: 10),
                showMilliseconds: true,
                slowBlinkingThreshold: 0.5,
                fastBlinkingThreshold: 0.3,
              ),

              const SizedBox(height: 20),

              /// Example 2: Custom UI
              BlinkingTimer(
                duration: const Duration(seconds: 11),
                initialColor: Colors.blue,
                warningColor: Colors.orange,
                criticalColor: Colors.red,
                customTimerUI: (text, color, progress, _, isBlinking) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 75,
                        height: 75,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          color: color,
                          backgroundColor: color.withOpacity(0.1),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            text,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  isBlinking ? color.withOpacity(0.7) : color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${(progress * 100).toStringAsFixed(0)}%",
                            style: TextStyle(color: color.withOpacity(0.8)),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              /// Example 3: Advance Usage using Controller
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlinkingTimer(
                    duration: const Duration(minutes: 1),
                    controller: timerController,
                    onTimeUpThreshold: () => debugPrint('Time up!'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: timerController.pause,
                        child: Text('Pause'),
                      ),
                      ElevatedButton(
                        onPressed: timerController.resume,
                        child: Text('Resume'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            timerController.restart(Duration(minutes: 1)),
                        child: Text('Restart Timer'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // home: const StartScreen(),
    );
  }
}
