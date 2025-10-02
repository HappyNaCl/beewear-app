import 'package:beewear_app/domain/models/region.dart';

abstract class RegionRepository {
  Future<List<Region>> fetchRegions();
}