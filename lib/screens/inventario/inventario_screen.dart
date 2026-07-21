import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/activo.dart';
import '../../providers/activo_provider.dart';
import '../../repositories/activo_repository.dart';
import 'nuevo_activo_screen.dart';

class InventarioScreen extends ConsumerStatefulWidget {
  const InventarioScreen({super.key});

  @override
  ConsumerState<InventarioScreen> createState() =>
      _InventarioScreenState();
}

class _InventarioScreenState extends ConsumerState<InventarioScreen> {
  int paginaActual = 0;
  final int elementosPorPagina = 5;
  String busquedaSerie = '';

  static const Color _primary = Color(0xFF173A5E);
  static const Color _secondary = Color(0xFF2D5F8B);
  static const Color _background = Color(0xFFF4F6F9);
  static const Color _textPrimary = Color(0xFF1F2937);
  static const Color _textSecondary = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final activosAsync = ref.watch(activosProvider);

    return Scaffold(
      backgroundColor: _background,

      // BOTÓN NUEVO ACTIVO
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 4,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NuevoActivoScreen(),
            ),
          );

          ref.invalidate(activosProvider);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Nuevo activo',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: activosAsync.when(
        data: (activos) {
          final activosFiltrados = activos.where((activo) {
            final serie = activo.serie.toLowerCase();
            final busqueda = busquedaSerie.toLowerCase().trim();

            return serie.contains(busqueda);
          }).toList();

          final totalPaginas = activosFiltrados.isEmpty
              ? 1
              : (activosFiltrados.length / elementosPorPagina).ceil();

          final paginaSegura = paginaActual >= totalPaginas
              ? totalPaginas - 1
              : paginaActual;

          final inicio = paginaSegura * elementosPorPagina;

          final fin = (inicio + elementosPorPagina) >
                  activosFiltrados.length
              ? activosFiltrados.length
              : inicio + elementosPorPagina;

          final activosPagina = activosFiltrados.sublist(
            inicio,
            fin,
          );

          return Column(
            children: [
              // ============================================
              // ENCABEZADO
              // ============================================
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _primary,
                      _secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      12,
                      10,
                      20,
                      25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BARRA SUPERIOR
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Inventario',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const Padding(
                          padding: EdgeInsets.only(
                            left: 12,
                            top: 8,
                          ),
                          child: Text(
                            'Gestión de activos tecnológicos',
                            style: TextStyle(
                              color: Color(0xFFD9E6F2),
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // BUSCADOR
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Buscar por número de serie',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: _secondary,
                              ),
                              suffixIcon: busquedaSerie.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: _textSecondary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          busquedaSerie = '';
                                          paginaActual = 0;
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                            onChanged: (valor) {
                              setState(() {
                                busquedaSerie = valor;
                                paginaActual = 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ============================================
              // CONTENIDO
              // ============================================
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    22,
                    18,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // RESULTADOS
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7EEF5),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              color: _primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  busquedaSerie.isEmpty
                                      ? 'Activos registrados'
                                      : 'Resultados de búsqueda',
                                  style: const TextStyle(
                                    color: _textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  busquedaSerie.isEmpty
                                      ? '${activos.length} activos en el inventario'
                                      : '${activosFiltrados.length} resultados encontrados',
                                  style: const TextStyle(
                                    color: _textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // LISTADO
                      Expanded(
                        child: activosFiltrados.isEmpty
                            ? _estadoVacio()
                            : ListView.builder(
                                padding: const EdgeInsets.only(
                                  bottom: 90,
                                ),
                                itemCount: activosPagina.length,
                                itemBuilder: (context, index) {
                                  final activo =
                                      activosPagina[index];

                                  return _activoCard(
                                    context,
                                    activo,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // ============================================
              // PAGINACIÓN
              // ============================================
              if (activosFiltrados.isNotEmpty)
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    12,
                    18,
                    18,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFE5E7EB),
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        _paginationButton(
                          icon: Icons.chevron_left_rounded,
                          text: 'Anterior',
                          enabled: paginaSegura > 0,
                          onPressed: () {
                            setState(() {
                              paginaActual--;
                            });
                          },
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF0F6),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${paginaSegura + 1} / $totalPaginas',
                            style: const TextStyle(
                              color: _primary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        _paginationButton(
                          icon: Icons.chevron_right_rounded,
                          text: 'Siguiente',
                          iconRight: true,
                          enabled:
                              paginaSegura < totalPaginas - 1,
                          onPressed: () {
                            setState(() {
                              paginaActual++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },

        loading: () => const Center(
          child: CircularProgressIndicator(
            color: _primary,
          ),
        ),

        error: (error, stack) => Center(
          child: Text(
            'No se pudo cargar el inventario.\n$error',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // ============================================
  // TARJETA DE ACTIVO
  // ============================================
  Widget _activoCard(
    BuildContext context,
    Activo activo,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.03,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _mostrarDetalleActivo(
              context,
              activo,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF0F6),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    _iconoCategoria(activo.idCategoria),
                    color: _primary,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${activo.marca} ${activo.modelo}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(
                            Icons.tag_rounded,
                            size: 14,
                            color: _textSecondary,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              activo.serie,
                              style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      _estadoBadge(activo.estado),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: _secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================
  // ESTADO DEL ACTIVO
  // ============================================
  Widget _estadoBadge(String estado) {
    IconData icon;

    if (estado == 'Asignado') {
      icon = Icons.person_outline_rounded;
    } else if (estado == 'Mantenimiento') {
      icon = Icons.build_outlined;
    } else {
      icon = Icons.inventory_2_outlined;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: _secondary,
        ),
        const SizedBox(width: 5),
        Text(
          estado,
          style: const TextStyle(
            color: _secondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================
  // ICONOS POR CATEGORÍA
  // ============================================
  IconData _iconoCategoria(int idCategoria) {
    switch (idCategoria) {
      case 1:
        return Icons.computer_rounded;
      case 2:
        return Icons.print_rounded;
      case 3:
        return Icons.phone_android_rounded;
      case 4:
        return Icons.radio_rounded;
      default:
        return Icons.devices_other_rounded;
    }
  }

  // ============================================
  // ESTADO SIN RESULTADOS
  // ============================================
  Widget _estadoVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF0F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 34,
              color: _primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No se encontraron activos',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Verifica el número de serie ingresado',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // BOTÓN PAGINACIÓN
  // ============================================
  Widget _paginationButton({
    required IconData icon,
    required String text,
    required bool enabled,
    required VoidCallback onPressed,
    bool iconRight = false,
  }) {
    final children = [
      Icon(
        icon,
        size: 18,
      ),
      const SizedBox(width: 3),
      Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];

    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: _primary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:
            iconRight ? children.reversed.toList() : children,
      ),
    );
  }

  // ============================================
  // DETALLE DEL ACTIVO
  // ============================================
  void _mostrarDetalleActivo(
    BuildContext context,
    Activo activo,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _iconoCategoria(activo.idCategoria),
                  color: _primary,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Detalle del activo',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _detalle('Serie', activo.serie),
                _detalle('Marca', activo.marca),
                _detalle('Modelo', activo.modelo),
                _detalle('Estado', activo.estado),
                _detalle(
                  'Condición física',
                  activo.condicionFisica ??
                      'Sin información',
                ),
                _detalle(
                  'Ubicación',
                  activo.ubicacion ??
                      'Sin información',
                ),

                const Divider(height: 28),

                _detalle(
                  'Observaciones',
                  activo.observaciones?.isNotEmpty == true
                      ? activo.observaciones!
                      : 'Sin observaciones',
                ),
              ],
            ),
          ),

          actionsAlignment: MainAxisAlignment.spaceBetween,

          actions: [
            IconButton(
              tooltip: 'Eliminar',
              onPressed: () async {
                Navigator.pop(dialogContext);

                await _confirmarEliminacion(
                  context,
                  activo,
                );
              },
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cerrar'),
                ),

                const SizedBox(width: 5),

                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: _primary,
                  ),
                  onPressed: () async {
                    Navigator.pop(dialogContext);

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            NuevoActivoScreen(
                          activo: activo,
                        ),
                      ),
                    );

                    ref.invalidate(activosProvider);
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                  ),
                  label: const Text('Editar'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ============================================
  // CONFIRMAR ELIMINACIÓN
  // ============================================
  Future<void> _confirmarEliminacion(
    BuildContext context,
    Activo activo,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text('Eliminar activo'),
            ],
          ),
          content: Text(
            '¿Deseas eliminar definitivamente el activo '
            '${activo.marca} ${activo.modelo} con serie '
            '${activo.serie}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              icon: const Icon(
                Icons.delete_outline,
              ),
              label: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    try {
      await ActivoRepository().eliminarActivo(
        activo.idActivo!,
      );

      ref.invalidate(activosProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Activo eliminado correctamente',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo eliminar el activo.',
          ),
        ),
      );
    }
  }

  // ============================================
  // FILA DE DETALLE
  // ============================================
  Widget _detalle(
    String titulo,
    String valor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              titulo,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}