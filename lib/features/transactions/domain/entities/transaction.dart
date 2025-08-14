import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String type;
  final double amount;
  final String categoryId;
  final String notes;
  final DateTime dateTime;
  final String account;
  final String? attachmentPath;
  final String recurrence;
  final bool isRecurringGenerated;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.notes,
    required this.dateTime,
    required this.account,
    this.attachmentPath,
    required this.recurrence,
    this.isRecurringGenerated = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Transaction copyWith({
    String? id,
    String? type,
    double? amount,
    String? categoryId,
    String? notes,
    DateTime? dateTime,
    String? account,
    String? attachmentPath,
    String? recurrence,
    bool? isRecurringGenerated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      notes: notes ?? this.notes,
      dateTime: dateTime ?? this.dateTime,
      account: account ?? this.account,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      recurrence: recurrence ?? this.recurrence,
      isRecurringGenerated: isRecurringGenerated ?? this.isRecurringGenerated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isIncome => type == 'income';
  bool get isExpense => type == 'expense';
  bool get hasRecurrence => recurrence != 'none';

  @override
  List<Object?> get props => [
    id,
    type,
    amount,
    categoryId,
    notes,
    dateTime,
    account,
    attachmentPath,
    recurrence,
    isRecurringGenerated,
    createdAt,
    updatedAt,
  ];
}
