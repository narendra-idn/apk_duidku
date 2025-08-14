import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/transaction_providers.dart';

class TransactionsDashboard extends ConsumerWidget {
  const TransactionsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayReportAsync = ref.watch(todayReportProvider);
    final monthlyReportAsync = ref.watch(monthlySummaryProvider);
    final overallBalanceAsync = ref.watch(overallBalanceProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.dashboard,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Financial Dashboard',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // laporan hari ini
            Text(
              'Laporan\nHari ini',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            
            const SizedBox(height: 12),
            
            todayReportAsync.when(
              data: (todayReport) => Row(
                children: [
                  Expanded(
                    child: _ReportCard(
                      title: 'Pemasukan\nHari ini',
                      amount: todayReport.income,
                      color: AppTheme.incomeColor,
                      icon: Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ReportCard(
                      title: 'Pengeluaran\nHari ini',
                      amount: todayReport.expenses,
                      color: AppTheme.expenseColor,
                      icon: Icons.trending_down,
                    ),
                  ),
                ],
              ),
              loading: () => const _LoadingCards(),
              error: (error, _) => _ErrorCard('Error loading today\'s report'),
            ),
            
            const SizedBox(height: 20),
            
            // laporan bulan ini
            Text(
              'Laporan\nBulan ini',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            
            const SizedBox(height: 12),
            
            monthlyReportAsync.when(
              data: (monthlyReport) => Row(
                children: [
                  Expanded(
                    child: _ReportCard(
                      title: 'Pemasukan\nBulan ini',
                      amount: monthlyReport.income,
                      color: AppTheme.incomeColor,
                      icon: Icons.calendar_month,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ReportCard(
                      title: 'Pengeluaran\nBulan ini',
                      amount: monthlyReport.expenses,
                      color: AppTheme.expenseColor,
                      icon: Icons.calendar_month,
                    ),
                  ),
                ],
              ),
              loading: () => const _LoadingCards(),
              error: (error, _) => _ErrorCard('Error loading monthly report'),
            ),
            
            const SizedBox(height: 20),
            
            // total uang
            Text(
              'Total',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            
            const SizedBox(height: 12),
            
            overallBalanceAsync.when(
              data: (overallBalance) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: overallBalance.totalBalance >= 0
                      ? AppTheme.incomeColor.withOpacity(0.1)
                      : AppTheme.expenseColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: overallBalance.totalBalance >= 0
                        ? AppTheme.incomeColor.withOpacity(0.3)
                        : AppTheme.expenseColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          overallBalance.totalBalance >= 0
                              ? Icons.account_balance_wallet
                              : Icons.warning,
                          color: overallBalance.totalBalance >= 0
                              ? AppTheme.incomeColor
                              : AppTheme.expenseColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Total Saldo',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Formatters.formatIDR(overallBalance.totalBalance),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: overallBalance.totalBalance >= 0
                            ? AppTheme.incomeColor
                            : AppTheme.expenseColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dalam ${overallBalance.transactionCount} transaksi',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => _ErrorCard('Error loading overall balance'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const _ReportCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: color,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            Formatters.formatIDR(amount),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _LoadingCards extends StatelessWidget {
  const _LoadingCards();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  
  const _ErrorCard(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.errorColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.errorColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
