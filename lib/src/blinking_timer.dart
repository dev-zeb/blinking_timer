// Copyright (c) 2025, Sufi Aurangzeb Hossain.
// Licensed under the BSD 3-Clause License - see LICENSE file for details.

import 'dart:async';
import 'package:flutter/material.dart';

import 'blinking_controller.dart';

/// A highly customizable countdown timer with blinking effects that intensify
/// as time runs out.
class BlinkingTimer extends StatefulWidget {
  final BlinkingTimerController? controller;

  /// The total duration for the countdown
  final Duration duration;

  /// Whether to show milliseconds in the display
  final bool showMilliseconds;

  /// Custom widget builder for complete UI control
  final Widget Function(String timeText, Color textColor)? customTimerUI;

  /// Duration between slow blinks (default: 450ms)
  final Duration slowBlinkingDuration;

  /// Duration between fast blinks (default: 250ms)
  final Duration fastBlinkingDuration;

  /// Percentage threshold (0-1) when slow blinking starts (default: 0.25)
  final double slowBlinkingThreshold;

  /// Percentage threshold (0-1) when fast blinking starts (default: 0.10)
  final double fastBlinkingThreshold;

  /// Initial timer color (default: Colors.blue)
  final Color initialColor;

  /// Warning level color (default: Colors.orange)
  final Color warningColor;

  /// Critical level color (default: Colors.red)
  final Color criticalColor;

  /// Color when timer ends (default: Colors.red)
  final Color endedColor;

  /// Whether to start timer automatically (default: true)
  final bool autoStart;

  /// Text style for the timer display
  final TextStyle? textStyle;

  /// Stroke width for circular progress (default: 6.0)
  final double progressStrokeWidth;

  /// Whether to show circular progress (default: true)
  final bool showProgress;

  /// Text to display when time is up (default: "Time Up!")
  final String timeUpText;

  /// Callback when slow blinking threshold is reached
  final VoidCallback? onWarningThreshold;

  /// Callback when fast blinking threshold is reached
  final VoidCallback? onCriticalThreshold;

  /// Callback when timer reaches zero
  final VoidCallback? onTimeUpThreshold;

  /// Background color for the default timer widget
  final Color? backgroundColor;

  /// Border radius for the default timer widget
  final BorderRadius? borderRadius;

  /// Padding for the default timer widget
  final EdgeInsets? padding;

  BlinkingTimer({
    super.key,
    required this.duration,
    this.onTimeUpThreshold,
    this.controller,
    this.showMilliseconds = false,
    this.customTimerUI,
    this.slowBlinkingDuration = const Duration(milliseconds: 450),
    this.fastBlinkingDuration = const Duration(milliseconds: 250),
    this.slowBlinkingThreshold = 0.25,
    this.fastBlinkingThreshold = 0.10,
    this.initialColor = Colors.blue,
    this.warningColor = Colors.orange,
    this.criticalColor = Colors.red,
    this.endedColor = Colors.red,
    this.autoStart = true,
    this.textStyle,
    this.progressStrokeWidth = 6.0,
    this.showProgress = true,
    this.timeUpText = "Time Up!",
    this.onWarningThreshold,
    this.onCriticalThreshold,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  })  : assert(duration.inMilliseconds > 0, 'Duration must be positive'),
        assert(slowBlinkingThreshold > fastBlinkingThreshold,
            'Slow blinking threshold must be greater than fast blinking threshold');

  @override
  State<BlinkingTimer> createState() => _BlinkingTimerState();
}

class _BlinkingTimerState extends State<BlinkingTimer>
    with TickerProviderStateMixin
    implements TimerStateController {
  Timer? _countdownTimer;
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  int _remainingMilliseconds = 0;
  bool _warningTriggered = false;
  bool _criticalTriggered = false;

  @override
  void initState() {
    super.initState();
    _remainingMilliseconds = widget.duration.inMilliseconds;

    _blinkController = AnimationController(
      vsync: this,
      duration: widget.slowBlinkingDuration,
    )..addListener(() => setState(() {}));

    _blinkAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _blinkController,
        curve: Curves.easeInOut,
      ),
    );

    // Schedule attachment for the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller?.attach(this);
    });

    if (widget.autoStart) {
      _startCountdownTimer();
    }
  }

  void _startCountdownTimer() {
    const updateInterval = Duration(milliseconds: 50);
    final decrementAmount = updateInterval.inMilliseconds;

    _countdownTimer = Timer.periodic(updateInterval, (timer) {
      if (_remainingMilliseconds > 0) {
        setState(() {
          _remainingMilliseconds -= decrementAmount;
          if (_remainingMilliseconds < 0) _remainingMilliseconds = 0;
        });
        _updateBlinking();
      } else {
        _stopBlinking();
        timer.cancel();
        widget.onTimeUpThreshold?.call();
      }
    });
  }

  @override
  void pause() {
    _countdownTimer?.cancel();
    _blinkController.stop();
  }

  @override
  void resume() {
    if (_countdownTimer?.isActive ?? false) return;
    _startCountdownTimer();
  }

  @override
  void restart(Duration? newDuration) {
    _countdownTimer?.cancel();
    _blinkController.stop();

    setState(() {
      _remainingMilliseconds =
          newDuration?.inMilliseconds ?? widget.duration.inMilliseconds;
      _warningTriggered = false;
      _criticalTriggered = false;
    });

    _startCountdownTimer();
  }

  void _updateBlinking() {
    final progress = _remainingMilliseconds / widget.duration.inMilliseconds;
    if (progress <= widget.fastBlinkingThreshold && !_criticalTriggered) {
      _criticalTriggered = true;
      widget.onCriticalThreshold?.call();
      _blinkController.duration = widget.fastBlinkingDuration;
      _blinkController.repeat(reverse: true);
    } else if (progress <= widget.slowBlinkingThreshold && !_warningTriggered) {
      _warningTriggered = true;
      widget.onWarningThreshold?.call();
      _blinkController.duration = widget.slowBlinkingDuration;
      _blinkController.repeat(reverse: true);
    }
  }

  void _stopBlinking() {
    _blinkController.stop();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _blinkController.dispose();
    super.dispose();
  }

  String _formatTime() {
    final hours = (_remainingMilliseconds ~/ 3600000);
    final minutes = ((_remainingMilliseconds % 3600000) ~/ 60000);
    final seconds = ((_remainingMilliseconds % 60000) ~/ 1000);
    final milliseconds = _remainingMilliseconds % 1000;

    String timeText = hours > 0 ? "${hours.toString().padLeft(2, '0')}:" : "";
    timeText +=
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    if (widget.showMilliseconds) {
      timeText += ".${(milliseconds ~/ 10).toString().padLeft(2, '0')}";
    }

    return timeText;
  }

  Color _getTextColor() {
    if (_remainingMilliseconds <= 0) return widget.endedColor;

    final progress = _remainingMilliseconds / widget.duration.inMilliseconds;
    final Color color = progress <= widget.fastBlinkingThreshold
        ? widget.criticalColor
        : progress <= widget.slowBlinkingThreshold
            ? widget.warningColor
            : widget.initialColor;

    return Color.lerp(
      color.withAlpha(255), // Fully opaque
      color.withAlpha(128), // Half transparent (~50% opacity)
      _blinkAnimation.value, // Animation value (0-1)
    )!;
  }

  Color _getProgressColor() {
    if (_remainingMilliseconds <= 0) return widget.endedColor;

    final progress = _remainingMilliseconds / widget.duration.inMilliseconds;

    return progress <= widget.fastBlinkingThreshold
        ? widget.criticalColor
        : progress <= widget.slowBlinkingThreshold
            ? widget.warningColor
            : widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final timeText =
        _remainingMilliseconds > 0 ? _formatTime() : widget.timeUpText;
    final textColor = _getTextColor();
    final progressColor = _getProgressColor();
    final progress = _remainingMilliseconds / widget.duration.inMilliseconds;

    if (widget.customTimerUI != null) {
      return widget.customTimerUI!(timeText, textColor);
    }

    return Container(
      padding: widget.padding ??
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey[200],
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showProgress)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                value: _remainingMilliseconds > 0 ? progress : 1.0,
                strokeWidth: widget.progressStrokeWidth,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          const SizedBox(width: 8),
          Text(
            timeText,
            style: (widget.textStyle ??
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ))
                .copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
