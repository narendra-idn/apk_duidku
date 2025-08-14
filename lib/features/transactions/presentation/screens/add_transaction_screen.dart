import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/category.dart';
import '../providers/transaction_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final String? initialType;

  const AddTransactionScreen({super.key, this.initialType});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(transactionFormProvider.notifier)
            .updateType(widget.initialType!);
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(transactionFormProvider);
    final formNotifier = ref.read(transactionFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: formState.isLoading
                ? null
                : () {
                    formNotifier.reset();
                    _amountController.clear();
                    _notesController.clear();
                  },
            child: const Text('Reset'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // tipe
              Text(
                'Tipe Transaksi',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: AppConstants.transactionTypeIncome,
                    label: Text('Pemasukan'),
                    icon: Icon(Icons.trending_up, color: AppTheme.incomeColor),
                  ),
                  ButtonSegment(
                    value: AppConstants.transactionTypeExpense,
                    label: Text('Pengeluaran'),
                    icon: Icon(
                      Icons.trending_down,
                      color: AppTheme.expenseColor,
                    ),
                  ),
                ],
                selected: {formState.type},
                onSelectionChanged: (selection) {
                  formNotifier.updateType(selection.first);
                },
              ),

              const SizedBox(height: 24),

              // jumlah
              Text(
                'Jumlah (IDR)',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: InputDecoration(
                  labelText: 'Masukkan jumlah',
                  prefixText: 'Rp ',
                  helperText: 'Contoh: 150000 untuk Rp 150.000',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan jumlah';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Silakan masukkan jumlah yang valid';
                  }
                  return null;
                },
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0.0;
                  formNotifier.updateAmount(amount);
                },
              ),

              const SizedBox(height: 24),

              // tgl
              Text(
                'Tanggal',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: formState.dateTime,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(formState.dateTime),
                    );
                    final dateTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time?.hour ?? formState.dateTime.hour,
                      time?.minute ?? formState.dateTime.minute,
                    );
                    formNotifier.updateDateTime(dateTime);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        Formatters.formatDateTime(formState.dateTime),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // catatan
              Text(
                'Catatan (Opsional)',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Tambahkan catatan atau deskripsi',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                onChanged: (value) {
                  formNotifier.updateNotes(value);
                },
              ),

              const SizedBox(height: 24),

              // kategori
              Text(
                'Kategori',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              Consumer(
                builder: (context, ref, child) {
                  final categoriesAsync = ref.watch(
                    categoriesByTypeProvider(formState.type),
                  );

                  return InkWell(
                    onTap: () async {
                      final categories = await categoriesAsync.when(
                        data: (categories) => categories,
                        loading: () => <Category>[],
                        error: (error, stackTrace) => <Category>[],
                      );

                      if (categories.isNotEmpty) {
                        final selectedCategory = await showDialog<Category>(
                          context: context,
                          builder: (context) => CategorySelectionDialog(
                            categories: categories,
                            transactionType: formState.type,
                          ),
                        );

                        if (selectedCategory != null) {
                          formNotifier.updateCategoryId(selectedCategory.id);
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: formState.categoryId.isEmpty
                              ? Colors.red.shade300
                              : Colors.grey.shade400,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: categoriesAsync.when(
                        data: (categories) {
                          final selectedCategory = categories.firstWhere(
                            (cat) => cat.id == formState.categoryId,
                            orElse: () => Category(
                              id: '',
                              name: '',
                              icon: Icons.category,
                              color: Colors.grey,
                              type: '',
                              isDefault: true,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            ),
                          );

                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  formState.categoryId.isEmpty
                                      ? 'Pilih kategori'
                                      : selectedCategory.name,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey.shade600,
                              ),
                            ],
                          );
                        },
                        loading: () => const Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Memuat kategori...'),
                          ],
                        ),
                        error: (error, stackTrace) => Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade600,
                            ),
                            const SizedBox(width: 12),
                            const Text('Error memuat kategori'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // error handling
              if (formState.error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withOpacity(0.1),
                    border: Border.all(
                      color: AppTheme.errorColor.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppTheme.errorColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          formState.error!,
                          style: TextStyle(color: AppTheme.errorColor),
                        ),
                      ),
                    ],
                  ),
                ),

              // tombol save
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: formState.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            if (formState.categoryId.isEmpty) {
                              return;
                            }

                            await formNotifier.saveTransaction();

                            if (formState.error == null && mounted) {
                              // refresh
                              refreshAllData(ref);

                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Transaksi tersimpan: ${Formatters.formatIDR(formState.amount)}',
                                  ),
                                  backgroundColor: AppTheme.successColor,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        formState.type == AppConstants.transactionTypeIncome
                        ? AppTheme.incomeColor
                        : AppTheme.expenseColor,
                    foregroundColor: Colors.white,
                  ),
                  child: formState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              formState.type ==
                                      AppConstants.transactionTypeIncome
                                  ? Icons.add_circle
                                  : Icons.remove_circle,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Simpan ${formState.type == AppConstants.transactionTypeIncome ? 'Pemasukan' : 'Pengeluaran'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategorySelectionDialog extends StatelessWidget {
  final List<Category> categories;
  final String transactionType;

  const CategorySelectionDialog({
    super.key,
    required this.categories,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context) {
    final title = transactionType == AppConstants.transactionTypeIncome
        ? 'Pilih Kategori Pemasukan'
        : 'Pilih Kategori Pengeluaran';

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 320),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // list kategori
            Flexible(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: categories.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return InkWell(
                    onTap: () => Navigator.of(context).pop(category),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        category.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
