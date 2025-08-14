import 'package:hive/hive.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String categoryId;

  @HiveField(4)
  final String notes;

  @HiveField(5)
  final DateTime dateTime;

  @HiveField(6)
  final String account;

  @HiveField(7)
  final String? attachmentPath;

  @HiveField(8)
  final String recurrence;

  @HiveField(10)
  final bool isRecurringGenerated;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  TransactionModel({
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

  Transaction toEntity() {
    return Transaction(
      id: id,
      type: type,
      amount: amount,
      categoryId: categoryId,
      notes: notes,
      dateTime: dateTime,
      account: account,
      attachmentPath: attachmentPath,
      recurrence: recurrence,
      isRecurringGenerated: isRecurringGenerated,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static TransactionModel fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      type: transaction.type,
      amount: transaction.amount,
      categoryId: transaction.categoryId,
      notes: transaction.notes,
      dateTime: transaction.dateTime,
      account: transaction.account,
      attachmentPath: transaction.attachmentPath,
      recurrence: transaction.recurrence,
      isRecurringGenerated: transaction.isRecurringGenerated,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
    );
  }

  TransactionModel copyWith({
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
    return TransactionModel(
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
}
