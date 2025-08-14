import '../../domain/entities/monthly_report.dart';
import '../../../transactions/domain/entities/transaction.dart';

abstract class ReportsRepository {
  /// total uang sekarang
  Future<double> getTotalBalance();
  
  /// laporan transaksi bulanan
  Future<List<MonthlyReport>> getMonthlyReports();
  
  /// laporan detail transaksi di bulan itu
  Future<List<Transaction>> getTransactionsForMonth(DateTime month);
  
  /// laporan bulan itu
  Future<MonthlyReport> getMonthlyReport(DateTime month);
}
