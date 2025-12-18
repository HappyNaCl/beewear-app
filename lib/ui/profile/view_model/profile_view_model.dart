import 'package:beewear_app/data/repositories/product/product_repository.dart';
import 'package:beewear_app/data/repositories/product/remote_product_repository.dart';
import 'package:beewear_app/domain/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileState {
  final bool isLoading;
  final int soldCount;
  final int activeCount;
  final List<Product> myProducts;

  ProfileState({
    this.isLoading = false,
    this.soldCount = 0,
    this.activeCount = 0,
    this.myProducts = const [],
  });
}

class ProfileViewModel extends StateNotifier<ProfileState> {
  final RemoteProductRepository _repo; 
  ProfileViewModel(this._repo) : super(ProfileState()) {
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    state = ProfileState(isLoading: true);
    
    final statsFuture = _repo.getMyStats();
    final productsFuture = _repo.getMyProducts();

    final results = await Future.wait([statsFuture, productsFuture]);
    final stats = results[0] as Map<String, int>;
    final products = results[1] as List<Product>;

    state = ProfileState(
      isLoading: false,
      soldCount: stats['sold']!,
      activeCount: stats['active']!,
      myProducts: products,
    );
  }
}

final profileViewModelProvider = StateNotifierProvider.autoDispose<ProfileViewModel, ProfileState>((ref) {

  final repo = ref.watch(productRepositoryProvider) as RemoteProductRepository;
  return ProfileViewModel(repo);
});