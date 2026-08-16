import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../../theme/app_colors.dart';
import '../../models/user_model.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _streetController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController(text: 'الخرطوم');

  // Selected label
  String _selectedLabel = 'منزل';
  final List<String> _labels = ['منزل', 'عمل', 'أخرى'];

  // Map placeholder lat/lng
  double _lat = 15.5007;
  double _lng = 32.5599;

  bool _isSaving = false;

  @override
  void dispose() {
    _streetController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Simulate save
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isSaving = false);

      final address = UserAddress(
        label: _selectedLabel,
        street: _streetController.text.trim(),
        district: _districtController.text.trim(),
        city: _cityController.text.trim(),
        lat: _lat,
        lng: _lng,
        isDefault: false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ العنوان بنجاح')),
      );

      // Return to previous screen
      context.pop(address);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.addAddress),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Label selector
              _buildLabelSelector(),
              const SizedBox(height: 16),
              // Street field
              _buildTextField(
                controller: _streetController,
                label: 'الشارع',
                hint: 'اسم الشارع أو المنطقة',
                icon: Icons.location_on_outlined,
                validator: (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال الشارع' : null,
              ),
              const SizedBox(height: 12),
              // District field
              _buildTextField(
                controller: _districtController,
                label: 'الحي / المنطقة',
                hint: 'اسم الحي أو المنطقة',
                icon: Icons.map_outlined,
                validator: (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال الحي' : null,
              ),
              const SizedBox(height: 12),
              // City field
              _buildTextField(
                controller: _cityController,
                label: 'المدينة',
                hint: 'اسم المدينة',
                icon: Icons.location_city,
                validator: (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال المدينة' : null,
              ),
              const SizedBox(height: 20),
              // Map preview
              _buildMapPreview(),
              const SizedBox(height: 24),
              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          AppStrings.save,
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نوع العنوان',
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _labels.map((label) {
              final isSelected = _selectedLabel == label;
              IconData icon;
              switch (label) {
                case 'منزل':
                  icon = Icons.home;
                  break;
                case 'عمل':
                  icon = Icons.business;
                  break;
                default:
                  icon = Icons.place;
              }
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: label != _labels.last ? 8 : 0,
                    right: label != _labels.first ? 8 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedLabel = label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            size: 22,
                            color: isSelected ? AppColors.primary : AppColors.textHint,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: GoogleFonts.cairo(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: GoogleFonts.cairo(fontSize: 14, color: AppColors.textSecondary),
          hintStyle: GoogleFonts.cairo(fontSize: 14, color: AppColors.textHint),
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.map, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'تحديد الموقع على الخريطة',
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Map placeholder (flutter_map compatible)
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(
              children: [
                // Static map placeholder
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 60,
                        color: AppColors.textHint.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'خريطة OpenStreetMap',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_lat, $_lng',
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          color: AppColors.textHint.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Pin marker
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      Icons.location_on,
                      size: 40,
                      color: AppColors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                // Tap to change location hint
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'اسحب لتغيير الموقع',
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Coordinates display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCoordChip('العرض', _lat),
              const SizedBox(width: 16),
              _buildCoordChip('الطول', _lng),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoordChip(String label, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        '$label: ${value.toStringAsFixed(4)}',
        style: GoogleFonts.cairo(
          fontSize: 11,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}