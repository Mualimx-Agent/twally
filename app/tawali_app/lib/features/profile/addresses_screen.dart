import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../models/user_model.dart';

// Sample addresses
final _sampleAddresses = [
  UserAddress(
    id: 'addr_1',
    label: 'المنزل',
    street: 'شارع 15',
    district: 'الرياض',
    city: 'الخرطوم',
    lat: 15.5007,
    lng: 32.5599,
    isDefault: true,
  ),
  UserAddress(
    id: 'addr_2',
    label: 'العمل',
    street: 'شارع الجامعة',
    district: 'العمارات',
    city: 'الخرطوم',
    lat: 15.5507,
    lng: 32.5899,
    isDefault: false,
  ),
  UserAddress(
    id: 'addr_3',
    label: 'المنزل الثاني',
    street: 'شارع النيل',
    district: 'أمدرمان',
    city: 'الخرطوم',
    lat: 15.6507,
    lng: 32.4799,
    isDefault: false,
  ),
];

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  ConsumerState<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  List<UserAddress> _addresses = List.from(_sampleAddresses);

  void _showAddEditDialog({UserAddress? address}) {
    final isEditing = address != null;
    final labelController = TextEditingController(text: address?.label ?? '');
    final streetController = TextEditingController(text: address?.street ?? '');
    final districtController =
        TextEditingController(text: address?.district ?? '');
    final cityController = TextEditingController(text: address?.city ?? 'الخرطوم');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(isEditing ? 'تعديل العنوان' : AppStrings.addAddress),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: labelController,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        labelText: 'تسمية (منزل، عمل...)',
                        hintText: 'مثال: المنزل',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'الحقل مطلوب' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: streetController,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        labelText: 'الشارع',
                        hintText: 'اسم الشارع',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'الحقل مطلوب' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: districtController,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        labelText: 'الحي',
                        hintText: 'اسم الحي',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'الحقل مطلوب' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: cityController,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        labelText: 'المدينة',
                        hintText: 'اسم المدينة',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'الحقل مطلوب' : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                final updated = UserAddress(
                  id: isEditing ? address.id : null,
                  label: labelController.text.trim(),
                  street: streetController.text.trim(),
                  district: districtController.text.trim(),
                  city: cityController.text.trim(),
                  lat: address?.lat ?? 15.5007,
                  lng: address?.lng ?? 32.5599,
                  isDefault: isEditing ? address.isDefault : false,
                );
                setState(() {
                  if (isEditing) {
                    final idx = _addresses.indexWhere((a) => a.id == address.id);
                    if (idx != -1) _addresses[idx] = updated;
                  } else {
                    _addresses.add(updated);
                  }
                });
                Navigator.of(ctx).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(isEditing ? AppStrings.save : AppStrings.addAddress),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteAddress(UserAddress address) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(AppStrings.delete),
          content: const Text('هل تريد حذف هذا العنوان؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text(AppStrings.delete),
            ),
          ],
        ),
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        setState(() {
          _addresses.removeWhere((a) => a.id == address.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف العنوان بنجاح')),
        );
      }
    });
  }

  void _setDefault(UserAddress address) {
    setState(() {
      _addresses = _addresses.map((a) {
        return a.copyWith(isDefault: a.id == address.id);
      }).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تعيين "${address.label}" كعنوان افتراضي')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(AppStrings.myAddresses),
        ),
        body: _addresses.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off,
                        size: 64, color: AppColors.textHint.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    const Text(
                      'لا توجد عناوين',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'أضف عنواناً جديداً للتوصيل',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final address = _addresses[index];
                  return Dismissible(
                    key: Key(address.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.white, size: 28),
                    ),
                    confirmDismiss: (_) async {
                      _deleteAddress(address);
                      return false; // handled in dialog
                    },
                    child: Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: address.isDefault
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: address.isDefault
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            address.label.contains('منزل')
                                ? Icons.home_outlined
                                : address.label.contains('عمل')
                                    ? Icons.work_outlined
                                    : Icons.location_on_outlined,
                            color: address.isDefault
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 22,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              address.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (address.isDefault) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'افتراضي',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Text(
                          '${address.street}، ${address.district}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!address.isDefault)
                              GestureDetector(
                                onTap: () => _setDefault(address),
                                child: const Icon(
                                  Icons.check_circle_outline,
                                  color: AppColors.textHint,
                                  size: 22,
                                ),
                              ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => _showAddEditDialog(address: address),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: AppColors.textHint,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _showAddEditDialog(address: address),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddEditDialog(),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}