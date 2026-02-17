import 'individual.dart';

/// Time range for the spending report.
enum ReportPeriod {
  daily,
  weekly,
  monthly,
}

/// A single shareholder's slice of the spending pie.
/// All dollar amounts are ILLUSTRATIVE — based on ownership % x tracked spending.
class ShareholderSlice {
  final Individual individual;
  final double spendingPercentage;
  final double illustrativeAmount;
  final List<String> viaCompanies;

  ShareholderSlice({
    required this.individual,
    required this.spendingPercentage,
    required this.illustrativeAmount,
    this.viaCompanies = const [],
  });

  String get illustrativeAmountDisplay => '~\$${illustrativeAmount.round()}';
  String get percentageDisplay => '${spendingPercentage.round()}%';
}

/// Spending report showing where tracked purchases flow.
/// Supports daily, weekly, and monthly time ranges.
class SpendingReport {
  final ReportPeriod period;
  final String periodLabel; // e.g., 'January 2026', 'Feb 10-16', 'Feb 16'
  final DateTime startDate;
  final DateTime endDate;
  final double totalTracked;
  final List<ShareholderSlice> slices;

  SpendingReport({
    required this.period,
    required this.periodLabel,
    required this.startDate,
    required this.endDate,
    required this.totalTracked,
    required this.slices,
  });

  String get totalDisplay => '\$${totalTracked.round()}';

  double get otherPercentage {
    final total = slices.fold(0.0, (sum, s) => sum + s.spendingPercentage);
    return (100 - total).clamp(0, 100);
  }

  double get otherAmount => totalTracked * (otherPercentage / 100);

  /// Navigate to the previous period
  DateTime get previousStart {
    switch (period) {
      case ReportPeriod.daily:
        return startDate.subtract(const Duration(days: 1));
      case ReportPeriod.weekly:
        return startDate.subtract(const Duration(days: 7));
      case ReportPeriod.monthly:
        return DateTime(startDate.year, startDate.month - 1, 1);
    }
  }

  /// Navigate to the next period
  DateTime get nextStart {
    switch (period) {
      case ReportPeriod.daily:
        return startDate.add(const Duration(days: 1));
      case ReportPeriod.weekly:
        return startDate.add(const Duration(days: 7));
      case ReportPeriod.monthly:
        return DateTime(startDate.year, startDate.month + 1, 1);
    }
  }

  /// Whether we can go forward (can't go past today)
  bool get canGoForward => nextStart.isBefore(DateTime.now());
}

// Backward compatibility — MonthlyReport still works everywhere
class MonthlyReport extends SpendingReport {
  final int year;
  final int month;
  final String monthLabel;

  MonthlyReport({
    required this.monthLabel,
    required this.year,
    required this.month,
    required super.totalTracked,
    required super.slices,
  }) : super(
          period: ReportPeriod.monthly,
          periodLabel: monthLabel,
          startDate: DateTime(year, month, 1),
          endDate: DateTime(year, month + 1, 0),
        );
}
