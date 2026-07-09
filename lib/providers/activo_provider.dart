import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/activo_repository.dart';

final activoRepositoryProvider = Provider<ActivoRepository>((ref) {
  return ActivoRepository();
});