import 'package:flutter/foundation.dart';

class PurchaseService extends ChangeNotifier {
  // Singleton instance
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  // Add purchase-related methods here
  
  void notifyPurchaseChange() {
    notifyListeners();
  }
}

// Global instance
final purchaseService = PurchaseService();
