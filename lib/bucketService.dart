import 'package:flutter/foundation.dart';

class BucketService extends ChangeNotifier {
  List<String> bucketItems = [];

  bool isEmpty() {
    return bucketItems.isEmpty;
  }

  addBucketItem(a) {
    bucketItems.add(a);
    notifyListeners(); // 데이터 변경 알림
  }

  // 다른 필요한 기능들을 구현할 수 있습니다.
}
