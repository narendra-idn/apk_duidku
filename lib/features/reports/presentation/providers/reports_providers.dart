import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/monthly_report.dart';
import '../../domain/repositories/reports_repository.dart';
import '../../data/repositories/reports_repository_impl.dart';
import '../../../transactions/domain/entities/transaction.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepositoryImpl();
});

// total uang
final totalBalanceProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getTotalBalance();
});

// laporan bulanan
final monthlyReportsProvider = FutureProvider<List<MonthlyReport>>((ref) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getMonthlyReports();
});

// transaksi bulanan
final monthlyTransactionsProvider = 
    FutureProvider.family<List<Transaction>, DateTime>((ref, month) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getTransactionsForMonth(month);
});

// laporan bulan itu
final monthlyReportProvider = 
    FutureProvider.family<MonthlyReport, DateTime>((ref, month) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getMonthlyReport(month);
});
