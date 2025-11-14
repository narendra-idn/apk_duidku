import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

//update
class CategoryRepositoryImpl implements CategoryRepository {
  late Box<CategoryModel> _categoryBox;
  late Box<TransactionModel> _transactionBox;
  final _uuid = const Uuid();

  CategoryRepositoryImpl() {
    if (Hive.isBoxOpen(AppConstants.hiveBoxCategories)) {
      _categoryBox = Hive.box<CategoryModel>(AppConstants.hiveBoxCategories);
    } else {
      throw Exception('Categories box is not open');
    }

    if (Hive.isBoxOpen(AppConstants.hiveBoxTransactions)) {
      _transactionBox = Hive.box<TransactionModel>(
        AppConstants.hiveBoxTransactions,
      );
    } else {
      throw Exception('Transactions box is not open');
    }
  }

  @override
  Future<List<Category>> getAllCategories() async {
    final models = _categoryBox.values.toList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    final model = _categoryBox.get(id);
    return model?.toEntity();
  }

  @override
  Future<List<Category>> getCategoriesByType(String type) async {
    final models = _categoryBox.values
        .where((model) => model.type == type || model.type == 'both')
        .toList();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addCategory(Category category) async {
    final model = CategoryModel.fromEntity(category);
    await _categoryBox.put(category.id, model);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final model = CategoryModel.fromEntity(category);
    await _categoryBox.put(category.id, model);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);
  }

  @override
  Future<void> seedDefaultCategories() async {
    if (_categoryBox.isNotEmpty) {
      return;
    }

    final now = DateTime.now();

    for (int i = 0; i < AppConstants.defaultCategories.length; i++) {
      final categoryData = AppConstants.defaultCategories[i];
      final categoryName = categoryData['name'] as String;
      final categoryType = categoryData['type'] as String;
      final fixedId =
          'default_${categoryType}_${categoryName.toLowerCase().replaceAll(' ', '_')}';

      final category = Category(
        id: fixedId,
        name: categoryName,
        icon: IconData(
          categoryData['icon'] as int,
          fontFamily: 'MaterialIcons',
        ),
        color: Color(categoryData['color'] as int),
        type: categoryType,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      );

      await addCategory(category);
    }
  }

  @override
  Future<bool> isCategoryInUse(String categoryId) async {
    final transactions = _transactionBox.values.toList();
    return transactions.any(
      (transaction) => transaction.categoryId == categoryId,
    );
  }
}
