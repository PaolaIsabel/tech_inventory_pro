import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/activo.dart';
import '../../providers/activo_provider.dart';

class AsignacionesScreen extends ConsumerStatefulWidget {
  const AsignacionesScreen({super.key});

  @override
  ConsumerState<AsignacionesScreen> createState() =>
      _AsignacionesScreenState();
}

class _AsignacionesScreenState
    extends ConsumerState<AsignacionesScreen> {
  int paginaActual = 0;
  final int elementosPorPagina = 5;

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
      body: activosAsync.when(
        data: (activos) {
          final asignados = activos
              .where((activo) => activo.estado == 'Asignado')
              .toList();

          final totalPaginas = asignados.isEmpty
              ? 1
              : (asignados.length / elementosPorPagina).ceil();

          final paginaSegura = paginaActual >= totalPaginas
              ? totalPaginas - 1
              : paginaActual;

          final inicio = paginaSegura * elementosPorPagina;

          final fin =
              (inicio + elementosPorPagina) > asignados.length
                  ? asignados.length
                  : inicio + elementosPorPagina;

          final asignadosPagina = asignados.isEmpty
              ? <Activo>[]
              : asignados.sublist(inicio, fin);

          return Column(
            children: [
              // ==========================================
              // ENCABEZADO
              // ==========================================
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
                      26,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              'Asignaciones',
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
                            'Control de activos asignados al personal',
                            style: TextStyle(
                              color: Color(0xFFD9E6F2),
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // RESUMEN
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: 0.12,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(
                                    alpha: 0.14,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(13),
                                ),
                                child: const Icon(
                                  Icons.assignment_ind_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${asignados.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Activos actualmente asignados',
                                    style: TextStyle(
                                      color: Color(0xFFD9E6F2),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ==========================================
              // CONTENIDO
              // ==========================================
              Expanded(
                child: asignados.isEmpty
                    ? _estadoVacio()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(
                          18,
                          22,
                          18,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Activos asignados',
                              style: TextStyle(
                                color: _textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Selecciona un activo para consultar su información',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 18),

                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount:
                                    asignadosPagina.length,
                                itemBuilder: (context, index) {
                                  return _tarjetaAsignacion(
                                    context,
                                    asignadosPagina[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              // ==========================================
              // PAGINACIÓN
              // ==========================================
              if (asignados.isNotEmpty)
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
                          enabled:
                              paginaSegura < totalPaginas - 1,
                          iconRight: true,
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
            'No se pudieron cargar las asignaciones.\n$error',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TARJETA DE ASIGNACIÓN
  // ==========================================
  Widget _tarjetaAsignacion(
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
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF0F6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.assignment_ind_outlined,
                    color: _primary,
                    size: 25,
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

                      const SizedBox(height: 7),

                      Row(
                        children: [
                          const Icon(
                            Icons.tag_rounded,
                            size: 14,
                            color: _textSecondary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            activo.serie,
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: _textSecondary,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              activo.ubicacion ??
                                  'Sin ubicación',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  // ==========================================
  // DETALLE
  // ==========================================
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
                child: const Icon(
                  Icons.assignment_ind_outlined,
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
                  'Condición',
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

          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _primary,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // SIN ASIGNACIONES
  // ==========================================
  Widget _estadoVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF0F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_ind_outlined,
              color: _primary,
              size: 38,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No existen activos asignados',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Los activos asignados aparecerán en esta sección',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PAGINACIÓN
  // ==========================================
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

  // ==========================================
  // FILA DE DETALLE
  // ==========================================
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
            width: 100,
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