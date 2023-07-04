import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BucketService extends ChangeNotifier {
  List<String> bucketItems = [];
  List<String> completedItems = [];

  bool isEmpty() {
    return bucketItems.isEmpty;
  }

  addBucketItem(a) {
    bucketItems.add(a);
    notifyListeners(); // 데이터 변경 알림
  }

  removeBucketItem(a) {
    bucketItems.remove(a);
    notifyListeners();
  }

  markAsCompleted(a) {
    bucketItems.remove(a);
    completedItems.add(a);
    notifyListeners();
  }
}
