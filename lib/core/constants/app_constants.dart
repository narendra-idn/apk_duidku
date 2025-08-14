class AppConstants {
  static const String appName = 'Duidku';
  static const String hiveBoxTransactions = 'transactions';
  static const String hiveBoxCategories = 'categories';

  // mata uang
  static const String defaultCurrency = 'IDR';

  // tipe transaksi
  static const String transactionTypeIncome = 'income';
  static const String transactionTypeExpense = 'expense';

  // pengulanagan
  static const String recurrenceNone = 'none';
  static const String recurrenceDaily = 'daily';
  static const String recurrenceWeekly = 'weekly';
  static const String recurrenceMonthly = 'monthly';

  // kategori
  static const List<Map<String, dynamic>> defaultCategories = [
    // pemasukan
    {
      'name': 'Gaji',
      'icon': 0xe064,
      'color': 0xFF4CAF50,
      'type': transactionTypeIncome,
    },
    {
      'name': 'Refund',
      'icon': 0xe5d5,
      'color': 0xFF8BC34A,
      'type': transactionTypeIncome,
    },
    {
      'name': 'Lain-lain',
      'icon': 0xe5c4,
      'color': 0xFF607D8B,
      'type': transactionTypeIncome,
    },

    // pengeluaran
    {
      'name': 'Makan',
      'icon': 0xe56c,
      'color': 0xFFFF9800,
      'type': transactionTypeExpense,
    },
    {
      'name': 'Transportasi',
      'icon': 0xe539,
      'color': 0xFF03A9F4,
      'type': transactionTypeExpense,
    },
    {
      'name': 'Sewa',
      'icon': 0xe80d,
      'color': 0xFFF44336,
      'type': transactionTypeExpense,
    },
    {
      'name': 'Kesehatan',
      'icon': 0xe550,
      'color': 0xFF009688,
      'type': transactionTypeExpense,
    },
    {
      'name': 'Hiburan',
      'icon': 0xe7f2,
      'color': 0xFF9C27B0,
      'type': transactionTypeExpense,
    },
    {
      'name': 'Pakaian',
      'icon': 0xe59c,
      'color': 0xFFE91E63,
      'type': transactionTypeExpense,
    },
    {
      'name': 'Pendidikan',
      'icon': 0xe80c,
      'color': 0xFF2196F3,
      'type': transactionTypeExpense,
    },
    {
      'name': 'Lain-lain',
      'icon': 0xe5c4,
      'color': 0xFF795548,
      'type': transactionTypeExpense,
    },
  ];
}
