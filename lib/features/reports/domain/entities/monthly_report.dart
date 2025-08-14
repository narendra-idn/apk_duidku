class MonthlyReport {
  final DateTime month;
  final double totalIncome;
  final double totalExpenses;
  final double netBalance;
  final int transactionCount;

  const MonthlyReport({
    required this.month,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netBalance,
    required this.transactionCount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonthlyReport &&
        other.month == month &&
        other.totalIncome == totalIncome &&
        other.totalExpenses == totalExpenses &&
        other.netBalance == netBalance &&
        other.transactionCount == transactionCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      month,
      totalIncome,
      totalExpenses,
      netBalance,
      transactionCount,
    );
  }

  @override
  String toString() {
    return 'MonthlyReport(month: $month, totalIncome: $totalIncome, totalExpenses: $totalExpenses, netBalance: $netBalance, transactionCount: $transactionCount)';
  }
}
