# Blinking Timer 🕒⏳

A customizable Flutter countdown timer widget with blinking effects that intensify as time runs out.

![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)

## Features ✨
- Fully customizable blinking effects (speed, thresholds)
- Progress visualization (circular/linear)
- Multiple timer control methods (play/pause/restart)
- Custom UI builder support
- Color transitions based on time remaining
- Precise time formatting (hours/minutes/seconds/milliseconds)

## Demo 🎥

| Basic Timer | Custom UI | Controller Example |
|-------------|-----------|---------------------|
| ![Basic](demo/basic.gif) | ![Custom](demo/custom.gif) | ![Controller](demo/controller.gif) |


## Installation 📦
Add to your `pubspec.yaml`:
```yaml
dependencies:
  blinking_timer: ^1.0.0
```

## Basic Usage 🚀
```dart
BlinkingTimer(
  duration: Duration(minutes: 2),
  onTimeUp: () => print('Time up!'),
  // Customize blinking behavior:
  slowBlinkingThreshold: 0.50, // 50% remaining
  fastBlinkingThreshold: 0.20, // 20% remaining
)
```

## Advanced Usage 🛠

### Custom UI
```dart
BlinkingTimer(
    duration: Duration(seconds: 10),
    customTimerUI: (text, color) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                text,
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
                    fontFamily: 'Segoe UI',
                ),
            ),
        );
    },
    timeUpText: 'Finish!!!',
);
```

### With Controller
```dart
late final BlinkingTimerController timerController;
final int minutes = 2;

@override
void initState() {
  super.initState();
  timerController = BlinkingTimerController();
}

@override
Widget build(BuildContext context) {

  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlinkingTimer(
              duration: const Duration(minutes: minutes),
              controller: timerController,
              onTimeUpThreshold: () => print('Time up!'),
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
                      timerController.restart(Duration(minutes: minutes)),
                  child: Text('Restart Timer'),
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
```

## Configuration Options ⚙️

| Parameter                | Type               | Default      | Description |
|--------------------------|--------------------|--------------|-------------|
| `duration`               | `Duration`         | **Required** | Total countdown duration |
| `onTimeUpThreshold`      | `VoidCallback?`    | `null`       | Called when timer reaches zero |
| `slowBlinkingThreshold`  | `double`           | `0.25`       | When slow blinking starts (0.0-1.0) |
| `fastBlinkingThreshold`  | `double`           | `0.10`       | When fast blinking starts (must be < slow threshold) |
| `customTimerUI`          | `Widget Function(String, Color)?` | `null`       | Builder for custom displays |
| `controller`             | `BlinkingTimerController?` | `null`       | Programmatic control |

## Troubleshooting 🔧

### Timer doesn't blink
- Ensure `slowBlinkingThreshold` > `fastBlinkingThreshold`
- Check if `onTimeUpThreshold` is properly wired

### Controller not working
- Verify `controller` is initialized before widget build
- Don't recreate the controller in `build()`

### UI not updating
- Wrap custom UI in `MaterialApp`/`CupertinoApp`
- Ensure parent widgets aren't blocking repaints

## Support the Project ❤️

If this package helped you, consider:

[![Buy Me A Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge)](https://buymeacoffee.com/yourusername)
