import 'package:beewear_app/data/repositories/region/region_repository.dart';
import 'package:beewear_app/data/source/remote/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/region.dart';

class RemoteRegionRepository implements RegionRepository {

  final ApiService apiService;

  const RemoteRegionRepository(this.apiService);

  @override
  Future<List<Region>> fetchRegions() async {
    final response = await apiService.getRegion();
    final List<dynamic> list = response["data"];
    return list.map((json) => Region.fromJson(json)).toList();
  }
}

final regionRepositoryProvider = Provider<RegionRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RemoteRegionRepository(apiService);
});
