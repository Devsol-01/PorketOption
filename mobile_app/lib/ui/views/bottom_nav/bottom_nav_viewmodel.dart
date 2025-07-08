import 'package:stacked/stacked.dart';

class BottomNavViewModel extends IndexTrackingViewModel {
  @override
  void setIndex(int value) {
    super.setIndex(value);
    rebuildUi();
  }
}
