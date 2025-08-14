import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  late Box<TransactionModel> _transactionBox;

  TransactionRepositoryImpl() {
    if (Hive.isBoxOpen(AppConstants.hiveBoxTransactions)) {
      _transactionBox = Hive.box<TransactionModel>(AppConstants.hiveBoxTransactions);
    } else {
      throw Exception('Transactions box is not open');
    }
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final models = _transactionBox.values.toList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    final model = _transactionBox.get(id);
    return model?.toEntity();
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    final models = _transactionBox.values.where((model) {
      final date = model.dateTime;
      return date.isAfter(start.subtract(const Duration(days: 1))) && 
             date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByCategory(String categoryId) async {
    final models = _transactionBox.values.where((model) => 
        model.categoryId == categoryId).toList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByType(String type) async {
    final models = _transactionBox.values.where((model) => 
        model.type == type).toList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByAccount(String account) async {
    final models = _transactionBox.values.where((model) => 
        model.account == account).toList();
    return models.map((model) => model.toEntity()).toList();
  }


  @override
  Future<List<Transaction>> searchTransactions(String query) async {
    final lowercaseQuery = query.toLowerCase();
    final models = _transactionBox.values.where((model) {
      return model.notes.toLowerCase().contains(lowercaseQuery) ||
             model.account.toLowerCase().contains(lowercaseQuery);
    }).toList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Transaction>> getRecurringTransactions() async {
    final models = _transactionBox.values.where((model) => 
        model.recurrence != AppConstants.recurrenceNone).toList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await _transactionBox.put(transaction.id, model);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await _transactionBox.put(transaction.id, model);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  @override
  Future<void> deleteAllTransactions() async {
    await _transactionBox.clear();
  }

  @override
  Future<double> getTotalByTypeAndDateRange(String type, DateTime start, DateTime end) async {
    final transactions = await getTransactionsByDateRange(start, end);
    return transactions
        .where((t) => t.type == type)
        .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Future<Map<String, double>> getCategoryTotalsForDateRange(DateTime start, DateTime end) async {
    final transactions = await getTransactionsByDateRange(start, end);
    final categoryTotals = <String, double>{};
    
    for (final transaction in transactions) {
      final categoryId = transaction.categoryId;
      categoryTotals[categoryId] = (categoryTotals[categoryId] ?? 0.0) + transaction.amount;
    }
    
    return categoryTotals;
  }
}
