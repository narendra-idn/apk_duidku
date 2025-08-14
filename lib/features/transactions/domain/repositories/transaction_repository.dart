import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getAllTransactions();
  Future<Transaction?> getTransactionById(String id);
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end);
  Future<List<Transaction>> getTransactionsByCategory(String categoryId);
  Future<List<Transaction>> getTransactionsByType(String type);
  Future<List<Transaction>> getTransactionsByAccount(String account);
  Future<List<Transaction>> searchTransactions(String query);
  Future<List<Transaction>> getRecurringTransactions();
  Future<void> addTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
  Future<void> deleteAllTransactions();
  Future<double> getTotalByTypeAndDateRange(String type, DateTime start, DateTime end);
  Future<Map<String, double>> getCategoryTotalsForDateRange(DateTime start, DateTime end);
}
