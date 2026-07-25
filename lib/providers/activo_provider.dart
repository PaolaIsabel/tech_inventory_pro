import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activo.dart';
import '../repositories/activo_repository.dart';

final activoRepositoryProvider = Provider<ActivoRepository>((ref) {
  return ActivoRepository();
});

final activosProvider = FutureProvider<List<Activo>>((ref) async {
  final repository = ref.read(activoRepositoryProvider);
  return repository.obtenerActivos();
});