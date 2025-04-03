import 'package:blinking_timer/blinking_timer.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const QuizMaster());
}

class QuizMaster extends StatefulWidget {
  const QuizMaster({super.key});

  @override
  State<QuizMaster> createState() => _QuizMasterState();
}

class _QuizMasterState extends State<QuizMaster> {
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
        backgroundColor: Colors.yellow,
        body: Center(
          // child: BlinkingTimer(
          //   duration: const Duration(seconds: 20),
          //   showMilliseconds: true,
          // ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlinkingTimer(
                duration: Duration(minutes: exampleMinute),
                controller: timerController,
                onTimeUpThreshold: () => debugPrint('Time up!'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: timerController.pause,
                    child: const Text('Pause'),
                  ),
                  ElevatedButton(
                    onPressed: timerController.resume,
                    child: const Text('Resume'),
                  ),
                  ElevatedButton(
                    onPressed: () => timerController.restart(
                      Duration(minutes: exampleMinute),
                    ),
                    child: const Text('Restart Timer'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
