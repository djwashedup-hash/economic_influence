import 'package:flutter/material.dart';
import '../models/monthly_report.dart';
import '../theme/app_theme.dart';
import '../widgets/spending_pie_chart.dart';
import '../widgets/shareholder_card.dart';
import '../data/report_generator.dart';
import '../services/purchase_service.dart';

class MonthlyReportScreen extends StatefulWidget {
  final SpendingReport? report;
  final Future<SpendingReport>? reportFuture;

  const MonthlyReportScreen({super.key, this.report, this.reportFuture});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  ReportPeriod _selectedPeriod = ReportPeriod.monthly;
  Future<SpendingReport>? _reportFuture;

  String get _headerTitle {
    switch (_selectedPeriod) {
      case ReportPeriod.daily:
        return 'Daily Report';
      case ReportPeriod.weekly:
        return 'Weekly Report';
      case ReportPeriod.monthly:
        return 'Monthly Report';
    }
  }

  SpendingReport _adjustForPeriod(SpendingReport base) {
    switch (_selectedPeriod) {
      case ReportPeriod.daily:
        final total = base.totalTracked > 0 ? base.totalTracked : 1.0;
        final ratio = 32.0 / total;
        return SpendingReport(
          period: ReportPeriod.daily,
          periodLabel: 'February 16, 2026',
          startDate: DateTime(2026, 2, 16),
          endDate: DateTime(2026, 2, 16),
          totalTracked: 32.0,
          slices: base.slices.map((s) {
            return ShareholderSlice(
              individual: s.individual,
              spendingPercentage: s.spendingPercentage,
              illustrativeAmount: s.illustrativeAmount * ratio,
              viaCompanies: s.viaCompanies,
            );
          }).toList(),
        );
      case ReportPeriod.weekly:
        final total = base.totalTracked > 0 ? base.totalTracked : 1.0;
        final ratio = 198.0 / total;
        return SpendingReport(
          period: ReportPeriod.weekly,
          periodLabel: 'Feb 10 – 16, 2026',
          startDate: DateTime(2026, 2, 10),
          endDate: DateTime(2026, 2, 16),
          totalTracked: 198.0,
          slices: base.slices.map((s) {
            return ShareholderSlice(
              individual: s.individual,
              spendingPercentage: s.spendingPercentage,
              illustrativeAmount: s.illustrativeAmount * ratio,
              viaCompanies: s.viaCompanies,
            );
          }).toList(),
        );
      case ReportPeriod.monthly:
        return base;
    }
  }

  @override
  void initState() {
    super.initState();
    _reportFuture = widget.reportFuture ??
        ReportGenerator.generateMonthly(DateTime.now().year, DateTime.now().month);
    // Listen for changes to purchases and refresh report automatically.
    purchaseService.addListener(_onPurchasesChanged);
  }

  void _onPurchasesChanged() {
    // Regenerate report for the current selected period
    setState(() {
      if (_selectedPeriod == ReportPeriod.monthly) {
        _reportFuture = ReportGenerator.generateMonthly(DateTime.now().year, DateTime.now().month);
      } else if (_selectedPeriod == ReportPeriod.weekly) {
        _reportFuture = ReportGenerator.generateWeekly(DateTime.now());
      } else if (_selectedPeriod == ReportPeriod.daily) {
        _reportFuture = ReportGenerator.generateDaily(DateTime.now());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpendingReport>(
      future: _reportFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final base = snapshot.data ?? (widget.report ?? SpendingReport(
          period: ReportPeriod.monthly,
          periodLabel: 'No data',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          totalTracked: 0,
          slices: [],
        ));
        final report = _adjustForPeriod(base);
        return _buildWithReport(context, report);
      },
    );
  }

  @override
  void dispose() {
    purchaseService.removeListener(_onPurchasesChanged);
    super.dispose();
  }

  Widget _buildWithReport(BuildContext context, SpendingReport report) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _headerTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.bgCard,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.refresh, size: 18),
                        color: AppTheme.textPrimary,
                        onPressed: () {
                          // Manual refresh
                          _onPurchasesChanged();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Period selector (Daily / Weekly / Monthly)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: ReportPeriod.values.map((period) {
                      final isSelected = _selectedPeriod == period;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedPeriod = period);
                            // Update the report future to the correct generator for the selected period
                            if (period == ReportPeriod.monthly) {
                              _reportFuture = ReportGenerator.generateMonthly(DateTime.now().year, DateTime.now().month);
                            } else if (period == ReportPeriod.weekly) {
                              _reportFuture = ReportGenerator.generateWeekly(DateTime.now());
                            } else if (period == ReportPeriod.daily) {
                              _reportFuture = ReportGenerator.generateDaily(DateTime.now());
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.accentBlue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              period == ReportPeriod.daily
                                  ? 'Daily'
                                  : period == ReportPeriod.weekly
                                      ? 'Weekly'
                                      : 'Monthly',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textMuted,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Date navigator
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _NavArrow(icon: Icons.chevron_left, onTap: () {}),
                    const SizedBox(width: 16),
                    Text(
                      report.periodLabel,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 16),
                    _NavArrow(
                      icon: Icons.chevron_right,
                      onTap: report.canGoForward ? () {} : null,
                    ),
                  ],
                ),
              ),
            ),

            // Illustrative warning
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentAmberDim,
                  border: Border.all(
                      color: AppTheme.accentAmber.withAlpha(51)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('⚠ ',
                        style:
                            TextStyle(fontSize: 13, color: AppTheme.accentAmber)),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Revenue flow to shareholders is illustrative — based on ownership percentages applied to your tracked spending. Actual financial flows are far more complex.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.accentAmber,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Section title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  'YOUR SPENDING → TOP SHAREHOLDERS',
                  style: TextStyle(
                    fontFamily: 'Space Mono',
                    fontSize: 10,
                    letterSpacing: 2,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ),

            // Pie chart + legend
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SpendingPieChart(report: report),
              ),
            ),

            // Shareholder cards section title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  'TOP SHAREHOLDERS — PUBLIC RECORD',
                  style: TextStyle(
                    fontFamily: 'Space Mono',
                    fontSize: 10,
                    letterSpacing: 2,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ),

            // Shareholder cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final slice = report.slices[index];
                    final color =
                        AppTheme.pieColors[index % AppTheme.pieColors.length];
                    return ShareholderCard(
                      slice: slice,
                      accentColor: color,
                    );
                  },
                  childCount: report.slices.length,
                ),
              ),
            ),

            // Disclaimer
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 100),
                child: Text(
                  'All dollar amounts are illustrative estimates based on ownership percentage x tracked spending. Actual financial flows involve complex corporate structures, taxes, reinvestment, and operating costs. Public record items sourced from government databases, court filings, and verified reporting. No moral scores assigned.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.textMuted,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _NavArrow({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? AppTheme.border : AppTheme.border.withAlpha(80),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppTheme.textSecondary : AppTheme.textMuted.withAlpha(80),
        ),
      ),
    );
  }
}
