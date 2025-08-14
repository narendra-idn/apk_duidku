import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/constants/app_constants.dart';
import 'features/transactions/data/models/transaction_model.dart';
import 'features/transactions/data/models/category_model.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('id_ID', null);
  
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  
  await Hive.openBox<TransactionModel>(AppConstants.hiveBoxTransactions);
  await Hive.openBox<CategoryModel>(AppConstants.hiveBoxCategories);
  
  runApp(
    const ProviderScope(
      child: FinanceTrackerApp(),
    ),
  );
}
