import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/transaction_providers.dart';

class MonthlySummaryCard extends StatelessWidget {
  final MonthlySummary summary;
  final String currency;

  const MonthlySummaryCard({
    super.key,
    required this.summary,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthName = Formatters.formatMonthYear(now);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  monthName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // pemasukan pengeluaran
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    label: 'Pemasukan',
                    amount: summary.income,
                    currency: currency,
                    color: AppTheme.incomeColor,
                    icon: Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryItem(
                    label: 'Pengeluaran',
                    amount: summary.expenses,
                    currency: currency,
                    color: AppTheme.expenseColor,
                    icon: Icons.trending_down,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // jumlah uang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: summary.net >= 0 
                    ? AppTheme.incomeColor.withOpacity(0.1)
                    : AppTheme.expenseColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: summary.net >= 0 
                      ? AppTheme.incomeColor.withOpacity(0.3)
                      : AppTheme.expenseColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Total Saldo',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatCurrency(summary.net.abs(), currency),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: summary.net >= 0 
                          ? AppTheme.incomeColor
                          : AppTheme.expenseColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (summary.net < 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Deficit',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.expenseColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // jumlah transaksi
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${summary.transactionCount} transaksi di bulan ini',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final String currency;
  final Color color;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.currency,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          Formatters.formatCurrency(amount, currency),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
