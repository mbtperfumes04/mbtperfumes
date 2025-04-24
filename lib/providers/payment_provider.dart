import 'package:flutter/material.dart';
import 'package:mbtperfumes/controllers/payment_controller.dart';
import 'package:mbtperfumes/models/payment_model.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentController _paymentController = PaymentController();

  Map<String, List<PaymentModel>> _paymentsByOrder = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<PaymentModel> getPayments(String orderId) => _paymentsByOrder[orderId] ?? [];

  Future<void> fetchPaymentsForOrder(String orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final payments = await _paymentController.getPaymentsByOrder(orderId);
      _paymentsByOrder[orderId] = payments;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPayment(PaymentModel payment) async {
    await _paymentController.createPayment(payment);
    await fetchPaymentsForOrder(payment.orderId);
  }

  Future<void> updatePayment(PaymentModel payment) async {
    await _paymentController.updatePayment(payment);
    await fetchPaymentsForOrder(payment.orderId);
  }

  Future<void> deletePayment(String id, String orderId) async {
    await _paymentController.deletePayment(id);
    await fetchPaymentsForOrder(orderId);
  }
}
