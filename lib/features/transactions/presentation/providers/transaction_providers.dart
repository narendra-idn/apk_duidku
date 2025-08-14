import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../../reports/presentation/providers/reports_providers.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl();
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.read(categoryRepositoryProvider);
  return await repository.getAllCategories();
});

final categoriesByTypeProvider = FutureProvider.family<List<Category>, String>((ref, type) async {
  final repository = ref.read(categoryRepositoryProvider);
  return await repository.getCategoriesByType(type);
});

final globalRefreshProvider = StateProvider<int>((ref) => 0);

void refreshAllData(WidgetRef ref) {
  ref.read(globalRefreshProvider.notifier).state++;
  // transaksi
  ref.invalidate(transactionsProvider);
  ref.invalidate(categoriesProvider);
  ref.invalidate(transactionsByDateRangeProvider);
  ref.invalidate(todayTransactionsProvider);
  ref.invalidate(currentMonthTransactionsProvider);
  ref.invalidate(todayReportProvider);
  ref.invalidate(monthlySummaryProvider);
  ref.invalidate(overallBalanceProvider);
  // laporan
  ref.invalidate(totalBalanceProvider);
  ref.invalidate(monthlyReportsProvider);
  ref.invalidate(monthlyTransactionsProvider);
  ref.invalidate(monthlyReportProvider);
}

// all transaksi
final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final repository = ref.read(transactionRepositoryProvider);
  final transactions = await repository.getAllTransactions();
  
  // sort tgl baru
  transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  return transactions;
});

// transaksi per tgl
final transactionsByDateRangeProvider = 
    FutureProvider.family<List<Transaction>, DateRange>((ref, dateRange) async {
  final repository = ref.read(transactionRepositoryProvider);
  final transactions = await repository.getTransactionsByDateRange(
    dateRange.start,
    dateRange.end,
  );
  
  // Ssort tgl baru
  transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  return transactions;
});

// transaksi bulan ini
final currentMonthTransactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final now = DateTime.now();
  final start = DateUtils.getStartOfMonth(now);
  final end = DateUtils.getEndOfMonth(now);
  
  return ref.watch(transactionsByDateRangeProvider(DateRange(start, end)).future);
});

// transakasi hari ini
final todayTransactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final repository = ref.read(transactionRepositoryProvider);
  final today = DateTime.now();
  final startOfToday = DateTime(today.year, today.month, today.day);
  final endOfToday = DateTime(today.year, today.month, today.day, 23, 59, 59);
  
  final transactions = await repository.getTransactionsByDateRange(
    startOfToday,
    endOfToday,
  );
  
  transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  return transactions;
});

// laporan hari ini
final todayReportProvider = FutureProvider<TodayReport>((ref) async {
  final transactions = await ref.watch(todayTransactionsProvider.future);
  
  double income = 0.0;
  double expenses = 0.0;
  
  for (final transaction in transactions) {
    if (transaction.isIncome) {
      income += transaction.amount;
    } else {
      expenses += transaction.amount;
    }
  }
  
  return TodayReport(
    income: income,
    expenses: expenses,
    transactionCount: transactions.length,
  );
});

// rangkuman per-bulan
final monthlySummaryProvider = FutureProvider<MonthlySummary>((ref) async {
  final transactions = await ref.watch(currentMonthTransactionsProvider.future);
  
  double income = 0.0;
  double expenses = 0.0;
  final Map<String, double> categoryTotals = {};
  
  for (final transaction in transactions) {
    if (transaction.isIncome) {
      income += transaction.amount;
    } else {
      expenses += transaction.amount;
    }
    
    categoryTotals[transaction.categoryId] = 
        (categoryTotals[transaction.categoryId] ?? 0.0) + transaction.amount;
  }
  
  final topCategories = categoryTotals.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  
  return MonthlySummary(
    income: income,
    expenses: expenses,
    net: income - expenses,
    topCategories: topCategories.take(5).toList(),
    transactionCount: transactions.length,
  );
});

// total uang saat ini
final overallBalanceProvider = FutureProvider<OverallBalance>((ref) async {
  final transactions = await ref.watch(transactionsProvider.future);
  
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  
  for (final transaction in transactions) {
    if (transaction.isIncome) {
      totalIncome += transaction.amount;
    } else {
      totalExpenses += transaction.amount;
    }
  }
  
  return OverallBalance(
    totalIncome: totalIncome,
    totalExpenses: totalExpenses,
    totalBalance: totalIncome - totalExpenses,
    transactionCount: transactions.length,
  );
});

final transactionFormProvider = StateNotifierProvider<TransactionFormNotifier, TransactionFormState>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  return TransactionFormNotifier(repository);
});

class TransactionFormState {
  final String? id;
  final String type;
  final double amount;
  final String categoryId;
  final String notes;
  final DateTime dateTime;
  final String account;
  final String recurrence;
  final bool isLoading;
  final String? error;

  TransactionFormState({
    this.id,
    this.type = AppConstants.transactionTypeExpense,
    this.amount = 0.0,
    this.categoryId = '',
    this.notes = '',
    DateTime? dateTime,
    this.account = 'Main',
    this.recurrence = AppConstants.recurrenceNone,
    this.isLoading = false,
    this.error,
  }) : dateTime = dateTime ?? DateTime.now();

  TransactionFormState copyWith({
    String? id,
    String? type,
    double? amount,
    String? categoryId,
    String? notes,
    DateTime? dateTime,
    String? account,
    String? recurrence,
    bool? isLoading,
    String? error,
  }) {
    return TransactionFormState(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      notes: notes ?? this.notes,
      dateTime: dateTime ?? this.dateTime,
      account: account ?? this.account,
      recurrence: recurrence ?? this.recurrence,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  Transaction toTransaction() {
    final now = DateTime.now();
    return Transaction(
      id: id ?? const Uuid().v4(),
      type: type,
      amount: amount,
      categoryId: categoryId,
      notes: notes,
      dateTime: dateTime,
      account: account,
      recurrence: recurrence,
      createdAt: id == null ? now : now,
      updatedAt: now,
    );
  }
}

class TransactionFormNotifier extends StateNotifier<TransactionFormState> {
  final TransactionRepository _repository;

  TransactionFormNotifier(this._repository) : super(TransactionFormState());

  void updateType(String type) {
    state = state.copyWith(type: type, categoryId: '');
  }

  void updateAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  void updateCategoryId(String categoryId) {
    state = state.copyWith(categoryId: categoryId);
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void updateDateTime(DateTime dateTime) {
    state = state.copyWith(dateTime: dateTime);
  }

  void updateAccount(String account) {
    state = state.copyWith(account: account);
  }

  void updateRecurrence(String recurrence) {
    state = state.copyWith(recurrence: recurrence);
  }

  void loadTransaction(Transaction transaction) {
    state = TransactionFormState(
      id: transaction.id,
      type: transaction.type,
      amount: transaction.amount,
      categoryId: transaction.categoryId,
      notes: transaction.notes,
      dateTime: transaction.dateTime,
      account: transaction.account,
      recurrence: transaction.recurrence,
    );
  }

  void reset() {
    state = TransactionFormState();
  }

  Future<void> saveTransaction() async {
    if (state.categoryId.isEmpty || state.amount <= 0) {
      state = state.copyWith(error: 'Please fill in all required fields');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final transaction = state.toTransaction();
      
      if (state.id == null) {
        await _repository.addTransaction(transaction);
      } else {
        await _repository.updateTransaction(transaction);
      }
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to save transaction: $e',
      );
    }
  }
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange(this.start, this.end);
}

class MonthlySummary {
  final double income;
  final double expenses;
  final double net;
  final List<MapEntry<String, double>> topCategories;
  final int transactionCount;

  MonthlySummary({
    required this.income,
    required this.expenses,
    required this.net,
    required this.topCategories,
    required this.transactionCount,
  });
}

class TodayReport {
  final double income;
  final double expenses;
  final int transactionCount;

  TodayReport({
    required this.income,
    required this.expenses,
    required this.transactionCount,
  });

  double get net => income - expenses;
}

class OverallBalance {
  final double totalIncome;
  final double totalExpenses;
  final double totalBalance;
  final int transactionCount;

  OverallBalance({
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalBalance,
    required this.transactionCount,
  });
}
