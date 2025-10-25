# ⏳ Blinking Timer

*A customizable Flutter countdown timer widget with blinking effects that intensify as time runs out.*

[![pub package](https://img.shields.io/pub/v/blinking_timer.svg)](https://pub.dev/packages/blinking_timer)
[![License: BSD-3-clause](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%9D%A4-blue.svg)](https://flutter.dev)
[![GitHub Repo](https://img.shields.io/badge/GitHub-blinking-timer?logo=github)](https://github.com/dev-zeb/blinking_timer)

---

## 💖 Support the Project

If this package helps you, please consider:

- ⭐ Star the repo on GitHub: [blinking_timer](https://github.com/dev-zeb/blinking_timer)
- 💙 Like the package on pub.dev: [pub.dev/packages/blinking_timer](https://pub.dev/packages/blinking_timer)

Your support motivates continued improvements and maintenance!

---

## ✨ Features

- Fully customizable blinking effects (speed, thresholds)
- Progress visualization (circular/linear)
- Multiple timer control methods (play/pause/restart)
- Custom UI builder support
- Color transitions based on time remaining
- Precise time formatting (hours/minutes/seconds/milliseconds)

---

## 🎥 Demo

| Basic Timer | Custom UI | Controller Example |
|-------------|-----------|---------------------|
| ![basic_usage](https://github.com/dev-zeb/assets/blob/develop/projects/flutter/packages/blinking_timer/gif/basic_usage.gif) | ![custom_ui](https://github.com/dev-zeb/assets/blob/develop/projects/flutter/packages/blinking_timer/gif/custom_ui.gif) | ![with_controller](https://github.com/dev-zeb/assets/blob/develop/projects/flutter/packages/blinking_timer/gif/with_controller.gif) |

---

## Installation 📦
Add to your `pubspec.yaml`:
```yaml
dependencies:
  blinking_timer: ^1.0.2
```

---

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

---

## 🛠 Advanced Usage

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
  );
}
```

---

## ⚙️ Configuration Options

| Parameter                | Type               | Default      | Description |
|--------------------------|--------------------|--------------|-------------|
| `duration`               | `Duration`         | **Required** | Total countdown duration |
| `onTimeUpThreshold`      | `VoidCallback?`    | `null`       | Called when timer reaches zero |
| `slowBlinkingThreshold`  | `double`           | `0.25`       | When slow blinking starts (0.0-1.0) |
| `fastBlinkingThreshold`  | `double`           | `0.10`       | When fast blinking starts (must be < slow threshold) |
| `customTimerUI`          | `Widget Function(String timeText, Color textColor, double progress, bool shouldBlink, bool isBlinking,)?` | `null` | Builder for custom displays |
| `controller`             | `BlinkingTimerController?` | `null`       | Programmatic control |

---

## 🧪 Example Project

You can check a working example in
the [`example/`](https://github.com/dev-zeb/blinking_timer/tree/main/example) directory.
It demonstrates requesting multiple permissions with custom dialogs and configurations.

---

## 🔧 Troubleshooting

#### Timer doesn't blink
- Ensure `slowBlinkingThreshold` > `fastBlinkingThreshold`
- Check if `onTimeUpThreshold` is properly wired

#### Controller not working
- Verify `controller` is initialized before widget build
- Don't recreate the controller in `build()`

#### UI not updating
- Wrap custom UI in `MaterialApp`/`CupertinoApp`
- Ensure parent widgets aren't blocking repaints

---

## 🤝 Contributing

We’d love your help to make **Blinking Timer** even better!
Here’s how you can contribute:

1. 🍴 Fork the [repository](https://github.com/dev-zeb/blinking_timer)
2. 🧩 Create a feature or fix branch (`feature/my-new-feature`)
3. 🧪 Add tests and run `flutter test`
4. 🧾 Commit your changes (`git commit -m "Add new feature"`)
5. 🚀 Push to your branch and create a Pull Request

---

## 📜 License

This package is licensed under the **BSD-3-Clause License**.
Please take a look at the [LICENSE](LICENSE) file for details.

---

## 💬 Credits

Developed with ❤️ by **Sufi Aurangzeb Hossain**

> “Great code is not about complexity — it’s about clarity.”

