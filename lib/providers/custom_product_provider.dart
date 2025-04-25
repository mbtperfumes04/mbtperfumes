import 'package:flutter/material.dart';
import 'package:mbtperfumes/models/dummy_payment_method_model.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_product_model.dart';

class CustomProductProvider with ChangeNotifier {
  final List<CustomScentItem> _selectedScents = [];
  final List<CustomSizeItem> _selectedSizes = [];
  final List<DummyPaymentMethod> _availablePaymentMethods = [];
  String _selectedPaymentMethod = '';
  String _customName = '';

  List<CustomScentItem> get selectedScents => List.unmodifiable(_selectedScents);
  List<CustomSizeItem> get selectedSizes => List.unmodifiable(_selectedSizes);
  List<DummyPaymentMethod> get availablePaymentMethods => List.unmodifiable(_availablePaymentMethods);
  String get selectedPaymentMethod => _selectedPaymentMethod;
  String get customName => _customName;

  CustomProductProvider() {
    if(_availablePaymentMethods.isEmpty) {
      initData();
    }
  }

  void initData() async {
    _availablePaymentMethods.clear();

    _availablePaymentMethods.addAll(
      [
        DummyPaymentMethod(
            id: Uuid().v4(),
            label: 'PayPal',
            icon: Icons.paypal
        )
      ]
    );

    print('Now Data: ${availablePaymentMethods.length}');

    notifyListeners();
  }

  void clearPaymentMethods() {
    _availablePaymentMethods.clear();
    _selectedPaymentMethod = '';
    notifyListeners();
  }

  /// Resets payment list and re-initializes methods.
  void resetPaymentMethods() {
    clearPaymentMethods();
    initData();
  }

  void setSelectedPaymentMethod(String id) {
    if (_availablePaymentMethods.any((method) => method.id == id)) {
      _selectedPaymentMethod = id;
      notifyListeners();
    }
  }

  void addScent(CustomScentItem item) {
    _selectedScents.add(item);
    notifyListeners();
  }

  void updateScent(int index, CustomScentItem newItem) {
    if (index >= 0 && index < _selectedScents.length) {
      _selectedScents[index] = newItem;
      notifyListeners();
    }
  }

  void updateScentById(String id, CustomScentItem newItem) {
    final index = _selectedScents.indexWhere((item) => item.id == id);
    if (index != -1) {
      _selectedScents[index] = newItem;
      notifyListeners();
    }
  }

  void removeScentAt(int index) {
    if (index >= 0 && index < _selectedScents.length) {
      _selectedScents.removeAt(index);
      notifyListeners();
    }
  }

  void removeScent(String id) {
    _selectedScents.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearScents() {
    _selectedScents.clear();
    notifyListeners();
  }

  bool isScentSelected(CustomScentItem item) => _selectedScents.contains(item);
  bool isScentSelectedById(String id) => _selectedScents.any((item) => item.id == id);

  void addSize(CustomSizeItem sizeItem) {
    final exists = _selectedSizes.any((item) => item.id == sizeItem.id);
    if (!exists) {
      _selectedSizes.add(sizeItem);
      notifyListeners();
    }
  }

  void removeSize(String id) {
    _selectedSizes.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateSize(CustomSizeItem updatedItem) {
    final index = _selectedSizes.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _selectedSizes[index] = updatedItem;
      notifyListeners();
    }
  }

  void updateSizeById(String id, {int? size, int? quantity}) {
    final index = _selectedSizes.indexWhere((item) => item.id == id);
    if (index != -1) {
      final current = _selectedSizes[index];
      _selectedSizes[index] = CustomSizeItem(
        id: current.id,
        size: size ?? current.size,
        quantity: quantity ?? current.quantity,
      );
      notifyListeners();
    }
  }

  void updateSizes(List<CustomSizeItem> sizes) {
    _selectedSizes
      ..clear()
      ..addAll(sizes);
    notifyListeners();
  }

  void clearSizes() {
    _selectedSizes.clear();
    notifyListeners();
  }

  bool isSizeSelectedById(String id) => _selectedSizes.any((item) => item.id == id);

  void setCustomName(String name) {
    _customName = name;
    notifyListeners();
  }

  void clearCustomName() {
    _customName = '';
    notifyListeners();
  }
}
