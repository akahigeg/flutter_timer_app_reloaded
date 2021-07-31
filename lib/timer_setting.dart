class TimerSetting {
  static int changeMin(int min, String upOrDown) {
    int newMin;
    if (upOrDown == 'up') {
      newMin = min + 1;
    } else {
      newMin = min - 1;
    }
    if (newMin == 100) {
      newMin = 0;
    }
    if (newMin == -1) {
      newMin = 99;
    }
    return newMin;
  }

  static int changeSec(int sec, String upOrDown) {
    int newSec;
    if (upOrDown == 'up') {
      newSec = sec + 1;
    } else {
      newSec = sec - 1;
    }
    if (newSec == 60) {
      newSec = 0;
    }
    if (newSec == -1) {
      newSec = 59;
    }
    return newSec;
  }
}
