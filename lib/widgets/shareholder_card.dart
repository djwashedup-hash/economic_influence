import 'package:flutter/material.dart';
import '../models/monthly_report.dart';

class ShareholderCard extends StatelessWidget {
  final ShareholderSlice slice;
  final Color accentColor;

  const ShareholderCard({
    super.key,
    required this.slice,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder implementation
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(slice.individual.name),
            Text('${slice.percentageDisplay} - ${slice.illustrativeAmountDisplay}'),
          ],
        ),
      ),
    );
  }
}
