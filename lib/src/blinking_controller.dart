abstract class TimerStateController {
  void pause();

  void resume();

  void restart(Duration? newDuration);
}

class BlinkingTimerController {
  TimerStateController? _state;
  bool _isAttached = false;

  void attach(TimerStateController state) {
    _state = state;
    _isAttached = true;
  }

  void pause() {
    if (_isAttached) _state?.pause();
  }

  void resume() {
    if (_isAttached) _state?.resume();
  }

  void restart([Duration? newDuration]) {
    if (_isAttached) _state?.restart(newDuration);
  }

  void dispose() {
    _state = null;
    _isAttached = false;
  }
}
