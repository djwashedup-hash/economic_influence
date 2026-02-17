import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/monthly_report_screen.dart';
import 'screens/add_purchase_screen.dart';
import 'screens/receipt_scanner_screen.dart';
import 'data/report_generator.dart';

void main() {
  runApp(const EconomicInfluenceApp());
}

class EconomicInfluenceApp extends StatelessWidget {
  const EconomicInfluenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Economic Influence',
      theme: AppTheme.darkTheme,
      home: const AppShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    // Scan receipt (primary input method)
    const ReceiptScannerScreen(),
    // Manual entry (fallback)
    const AddPurchaseScreen(),
    // Alternatives screen — placeholder for now
    const Center(
      child: Text(
        'Alternatives\n(Coming soon)',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
      ),
    ),
    // Report (daily/weekly/monthly)
    MonthlyReportScreen(
      reportFuture: ReportGenerator.generateMonthly(DateTime.now().year, DateTime.now().month),
    ),
    // Settings — placeholder
    const Center(
      child: Text(
        'Settings\n(Coming soon)',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.border),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_rounded, size: 22),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 22),
              label: 'Manual',
            ),
            BottomNavigationBarItem(
              icon: Text('◎', style: TextStyle(fontSize: 20)),
              label: 'Alternatives',
            ),
            BottomNavigationBarItem(
              icon: Text('📊', style: TextStyle(fontSize: 20)),
              label: 'Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 20),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
