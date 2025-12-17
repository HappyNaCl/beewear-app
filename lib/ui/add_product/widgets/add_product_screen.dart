import 'package:beewear_app/routing/routes.dart';
import 'package:beewear_app/ui/add_product/view_model/add_product_view_model.dart';
import 'package:beewear_app/ui/core/layout/main_layout.dart';
import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:beewear_app/ui/home/view_model/products_notifier.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();

  String? _selectedGender;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addProductViewModelProvider);
    final viewModel = ref.read(addProductViewModelProvider.notifier);

    // Listener for Success/Error
    ref.listen(addProductViewModelProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product Created!'), backgroundColor: Colors.green),
        );
        // Refresh home feed
        ref.read(productsNotifierProvider.notifier).refresh();
        context.go(Routes.home);
      }
    });

    return MainLayout(
      currentIndex: 1, // Highlight 'Sell' tab
      child: Scaffold(
        appBar: AppBar(title: const Text('Sell Item')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Image Picker
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: viewModel.pickImage,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.grey1,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey3),
                          ),
                          child: Icon(Icons.add_a_photo, color: AppColors.grey3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ...state.selectedImages.asMap().entries.map((entry) {
                        return Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(entry.value),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 12,
                              child: GestureDetector(
                                onTap: () => viewModel.removeImage(entry.key),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // 3. Price
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price (IDR)',
                    border: OutlineInputBorder(),
                    prefixText: 'Rp ',
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // 4. Description
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Gender Dropdown
                DropdownButtonFormField2<String>(
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedGender,
                  items: const [
                    DropdownMenuItem(value: 'MALE', child: Text('Male')),
                    DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
                    DropdownMenuItem(value: 'UNISEX', child: Text('Unisex')),
                  ],
                  onChanged: (val) => setState(() => _selectedGender = val),
                  validator: (v) => v == null ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // 6. Category Dropdown
                DropdownButtonFormField2<String>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCategory,
                  items: const [
                    DropdownMenuItem(value: 'TOP', child: Text('Top')),
                    DropdownMenuItem(value: 'BOTTOM', child: Text('Bottom')),
                    DropdownMenuItem(value: 'SHOES', child: Text('Shoes')),
                    DropdownMenuItem(value: 'ACCESSORY', child: Text('Accessory')),
                  ],
                  onChanged: (val) => setState(() => _selectedCategory = val),
                  validator: (v) => v == null ? 'Required' : null,
                ),

                const SizedBox(height: 32),

                // 7. Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              viewModel.createProduct(
                                name: _nameController.text,
                                description: _descController.text,
                                price: double.parse(_priceController.text),
                                gender: _selectedGender!,
                                category: _selectedCategory!,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: state.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Post Product'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}