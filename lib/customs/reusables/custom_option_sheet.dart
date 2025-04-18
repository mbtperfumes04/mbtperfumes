import 'package:flutter/material.dart';
import 'package:mbtperfumes/globals.dart';

class OptionItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  OptionItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

void showCustomOptionSheet({
  required BuildContext context,
  required List<OptionItem> options,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: screenWidth * 0.03
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            ...options.map((item) => ListTile(
              leading: Icon(item.icon, size: screenWidth * 0.05),
              title: Text(item.title),
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02
              ),
              onTap: () {
                Navigator.of(context).pop();
                item.onTap();
              },
            )),
            SizedBox(height: screenHeight * 0.025)
          ],
        ),
      );
    },
  );
}
