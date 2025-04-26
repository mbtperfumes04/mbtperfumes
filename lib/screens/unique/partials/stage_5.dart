import 'package:flutter/material.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:provider/provider.dart';

import '../../../models/dummy_payment_method_model.dart';
import '../../../providers/custom_product_provider.dart';

class CustomStage5 extends StatefulWidget {
  const CustomStage5({super.key});

  @override
  State<CustomStage5> createState() => _CustomStage5State();
}

class _CustomStage5State extends State<CustomStage5> {
  List<DummyPaymentMethod> paymentMethods = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customProductProvider = Provider.of<CustomProductProvider>(context);

    final totalValue = customProductProvider
        .selectedSizes.fold(0.0, (sum, item) => ((item.size * perMlPrice) * item.quantity) + sum);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: screenHeight,
        child: ListView(
          children: [
            Column(
              children: [
                Text(
                  'Payment Section',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Text(
                    "Select a payment method you want to use.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.033,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF808080),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.07
              ),
              child: Divider(
                color: const Color(0xFF808080),
                thickness: 0.2,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              child: Column(
                children: [
                  Text('Total to Pay',
                    style: TextStyle(
                      color: const Color(0xFF808080)
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    width: screenWidth * 0.7,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.013
                    ),
                    child: Text('₱${totalValue.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Available Payment Methods',
                    style: TextStyle(
                        color: const Color(0xFF808080)
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: customProductProvider.availablePaymentMethods.map((method) {
                        print('s');
                        return PaymentMethodTile(
                          method: method,
                          onTap: () {
                            customProductProvider.setSelectedPaymentMethod(method.id);
                          },
                        );
                      }).toList(),
                    )

                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class PaymentMethodTile extends StatelessWidget {
  final DummyPaymentMethod method;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final customProductProvider = Provider.of<CustomProductProvider>(context);

    final bool isSelected = method.id == customProductProvider.selectedPaymentMethod;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFFE0E0E0),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              method.icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black54,
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              method.label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
