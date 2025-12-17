import 'dart:io';
import 'package:beewear_app/data/repositories/product/product_repository.dart';
import 'package:beewear_app/data/repositories/product/remote_product_repository.dart';
import 'package:beewear_app/data/source/remote/dto/request/create_product_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddProductState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final List<File> selectedImages;

  const AddProductState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.selectedImages = const [],
  });

  AddProductState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    List<File>? selectedImages,
  }) {
    return AddProductState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      selectedImages: selectedImages ?? this.selectedImages,
    );
  }
}

class AddProductViewModel extends StateNotifier<AddProductState> {
  final ProductRepository _repository;
  final ImagePicker _picker = ImagePicker();

  AddProductViewModel(this._repository) : super(const AddProductState());

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      state = state.copyWith(
        selectedImages: [...state.selectedImages, File(image.path)],
      );
    }
  }

  void removeImage(int index) {
    final images = [...state.selectedImages];
    images.removeAt(index);
    state = state.copyWith(selectedImages: images);
  }

  Future<bool> createProduct({
    required String name,
    required String description,
    required double price,
    required String gender,
    required String category,
  }) async {
    if (state.selectedImages.isEmpty) {
      state = state.copyWith(error: "Please select at least one image");
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final req = CreateProductRequest(
        name: name,
        description: description,
        price: price,
        gender: gender,
        category: category,
        images: state.selectedImages,
      );

      await _repository.createProduct(req);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void reset() {
    state = const AddProductState();
  }
}

final addProductViewModelProvider =
    StateNotifierProvider.autoDispose<AddProductViewModel, AddProductState>((
      ref,
    ) {
      final repo = ref.watch(productRepositoryProvider);
      return AddProductViewModel(repo);
    });
