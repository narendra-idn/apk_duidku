import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/monthly_report.dart';
import '../../domain/repositories/reports_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/data/models/transaction_model.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  late Box<TransactionModel> _transactionBox;

  ReportsRepositoryImpl() {
    if (Hive.isBoxOpen(AppConstants.hiveBoxTransactions)) {
      _transactionBox = Hive.box<TransactionModel>(AppConstants.hiveBoxTransactions);
    } else {
      throw Exception('Transactions box is not open');
    }
  }

  @override
  Future<double> getTotalBalance() async {
    final transactions = await _getAllTransactions();
    double totalIncome = 0;
    double totalExpenses = 0;

    for (final transaction in transactions) {
      if (transaction.type == AppConstants.transactionTypeIncome) {
        totalIncome += transaction.amount;
      } else if (transaction.type == AppConstants.transactionTypeExpense) {
        totalExpenses += transaction.amount;
      }
    }

    return totalIncome - totalExpenses;
  }

  @override
  Future<List<MonthlyReport>> getMonthlyReports() async {
    final transactions = await _getAllTransactions();
    final Map<String, List<Transaction>> monthlyTransactions = {};
    final now = DateTime.now();

    // grup transaksi bulan
    for (final transaction in transactions) {
      final monthKey = '${transaction.dateTime.year}-${transaction.dateTime.month.toString().padLeft(2, '0')}';
      monthlyTransactions.putIfAbsent(monthKey, () => []).add(transaction);
    }

    // laporan tiap bulan
    final reports = <MonthlyReport>[];
    for (final entry in monthlyTransactions.entries) {
      final monthTransactions = entry.value;
      final monthDate = DateTime(
        int.parse(entry.key.split('-')[0]),
        int.parse(entry.key.split('-')[1]),
        1,
      );

      double totalIncome = 0;
      double totalExpenses = 0;

      for (final transaction in monthTransactions) {
        if (transaction.type == AppConstants.transactionTypeIncome) {
          totalIncome += transaction.amount;
        } else if (transaction.type == AppConstants.transactionTypeExpense) {
          totalExpenses += transaction.amount;
        }
      }

      reports.add(MonthlyReport(
        month: monthDate,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        netBalance: totalIncome - totalExpenses,
        transactionCount: monthTransactions.length,
      ));
    }

    // sorting bulan tahun dari baru ke lama
    reports.sort((a, b) {
      
      if (a.month.year == now.year && b.month.year != now.year) {
        return -1;
      } else if (a.month.year != now.year && b.month.year == now.year) {
        return 1;
      } else {
        return b.month.compareTo(a.month);
      }
    });
    
    return reports;
  }

  @override
  Future<List<Transaction>> getTransactionsForMonth(DateTime month) async {
    final transactions = await _getAllTransactions();
    
    return transactions.where((transaction) {
      return transaction.dateTime.year == month.year &&
             transaction.dateTime.month == month.month;
    }).toList();
  }

  @override
  Future<MonthlyReport> getMonthlyReport(DateTime month) async {
    final transactions = await getTransactionsForMonth(month);
    
    double totalIncome = 0;
    double totalExpenses = 0;

    for (final transaction in transactions) {
      if (transaction.type == AppConstants.transactionTypeIncome) {
        totalIncome += transaction.amount;
      } else if (transaction.type == AppConstants.transactionTypeExpense) {
        totalExpenses += transaction.amount;
      }
    }

    return MonthlyReport(
      month: month,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      netBalance: totalIncome - totalExpenses,
      transactionCount: transactions.length,
    );
  }

  Future<List<Transaction>> _getAllTransactions() async {
    final models = _transactionBox.values.toList();
    final transactions = models.map((model) => model.toEntity()).toList();
    
    // sorting tgl desc
    transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return transactions;
  }
}
