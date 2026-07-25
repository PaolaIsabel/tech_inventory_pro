import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/activo.dart';
import '../../providers/activo_provider.dart';
import '../../repositories/computadora_repository.dart';
import '../../repositories/asignacion_repository.dart';

class ReportesScreen extends ConsumerStatefulWidget {
  const ReportesScreen({super.key});

  @override
  ConsumerState<ReportesScreen> createState() =>
      _ReportesScreenState();
}

class _ReportesScreenState extends ConsumerState<ReportesScreen> {
  String filtroEstado = 'Todos';
  String filtroCategoria = 'Todas';
  int paginaActual = 0;
  final int elementosPorPagina = 5;

  static const Color _primary = Color(0xFF173A5E);
  static const Color _secondary = Color(0xFF2D5F8B);
  static const Color _background = Color(0xFFF4F6F9);
  static const Color _textPrimary = Color(0xFF1F2937);
  static const Color _textSecondary = Color(0xFF6B7280);

  final List<String> categorias = [
    'Todas',
    'Computadora',
    'Impresora',
    'Celular',
    'Radio',
  ];

  final List<String> estados = [
    'Todos',
    'Almacén TIC',
    'Asignado',
    'En mantenimiento',
  ];

  @override
  Widget build(BuildContext context) {
    final activosAsync = ref.watch(activosProvider);

    return Scaffold(
      backgroundColor: _background,
      body: activosAsync.when(
        data: (activos) {
          final activosFiltrados = activos.where((activo) {
            final cumpleEstado =
                filtroEstado == 'Todos' ||
                activo.estado == filtroEstado;

            final cumpleCategoria =
                filtroCategoria == 'Todas' ||
                activo.idCategoria ==
                    _obtenerIdCategoria(filtroCategoria);

            return cumpleEstado && cumpleCategoria;
          }).toList();

          final totalPaginas = activosFiltrados.isEmpty
              ? 1
              : (activosFiltrados.length / elementosPorPagina)
                  .ceil();

          final paginaSegura = paginaActual >= totalPaginas
              ? totalPaginas - 1
              : paginaActual;

          final inicio = paginaSegura * elementosPorPagina;

          final fin =
              (inicio + elementosPorPagina) >
                      activosFiltrados.length
                  ? activosFiltrados.length
                  : inicio + elementosPorPagina;

          final activosPagina = activosFiltrados.sublist(
            inicio,
            fin,
          );

          return Column(
            children: [
              // ENCABEZADO
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
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
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
                              'Reportes',
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
                            'Consulta y análisis del inventario tecnológico',
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
                            borderRadius:
                                BorderRadius.circular(16),
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
                                  Icons.analytics_outlined,
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
                                    '${activosFiltrados.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Activos según los filtros aplicados',
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

              // CONTENIDO
              Expanded(
                child: Padding(
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
                        'Filtros de consulta',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Selecciona los criterios para consultar los activos',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // FILTRO ESTADO
                      _filtroContainer(
                        child:
                            DropdownButtonFormField<String>(
                          initialValue: filtroEstado,
                          isExpanded: true,
                          decoration:
                              const InputDecoration(
                            labelText: 'Estado',
                            prefixIcon: Icon(
                              Icons.tune_rounded,
                              color: _primary,
                            ),
                            border: InputBorder.none,
                          ),
                          items: estados.map((estado) {
                            return DropdownMenuItem(
                              value: estado,
                              child: Text(estado),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                filtroEstado = value;
                                paginaActual = 0;
                              });
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // FILTRO CATEGORÍA
                      _filtroContainer(
                        child:
                            DropdownButtonFormField<String>(
                          initialValue: filtroCategoria,
                          isExpanded: true,
                          decoration:
                              const InputDecoration(
                            labelText: 'Categoría',
                            prefixIcon: Icon(
                              Icons.category_outlined,
                              color: _primary,
                            ),
                            border: InputBorder.none,
                          ),
                          items:
                              categorias.map((categoria) {
                            return DropdownMenuItem(
                              value: categoria,
                              child: Text(categoria),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                filtroCategoria = value;
                                paginaActual = 0;
                              });
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Resultados',
                              style: TextStyle(
                                color: _textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFEAF0F6),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${activosFiltrados.length} activos',
                              style: const TextStyle(
                                color: _primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // LISTA
                      Expanded(
                        child: activosFiltrados.isEmpty
                            ? _estadoVacio()
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                itemCount:
                                    activosPagina.length,
                                itemBuilder:
                                    (context, index) {
                                  return _tarjetaActivo(
                                    context,
                                    activosPagina[index],
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // PAGINACIÓN
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
                          icon:
                              Icons.chevron_left_rounded,
                          text: 'Anterior',
                          enabled: paginaSegura > 0,
                          onPressed: () {
                            setState(() {
                              paginaActual--;
                            });
                          },
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFEAF0F6),
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
                          icon:
                              Icons.chevron_right_rounded,
                          text: 'Siguiente',
                          enabled: paginaSegura <
                              totalPaginas - 1,
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
            'Error al cargar el reporte:\n$error',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _filtroContainer({
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: child,
    );
  }

  // TARJETA
  Widget _tarjetaActivo(
    BuildContext context,
    Activo activo,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
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
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF0F6),
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                  child: Icon(
                    _iconoCategoria(
                      activo.idCategoria,
                    ),
                    color: _primary,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${activo.marca} ${activo.modelo}',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Serie: ${activo.serie}',
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        activo.ubicacion ??
                            'Sin ubicación',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 7,
                            color: _secondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            activo.estado,
                            style: const TextStyle(
                              color: _secondary,
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: _secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // DETALLE COMPLETO
  Future<void> _mostrarDetalleActivo(
    BuildContext context,
    Activo activo,
  ) async {
    final computadoraRepository =
        ComputadoraRepository();

    final asignacionRepository =
        AsignacionRepository();

    final computadora = activo.idCategoria == 1
        ? await computadoraRepository
            .obtenerPorActivo(activo.idActivo!)
        : null;

    final asignacion =
        activo.estado == 'Asignado'
            ? await asignacionRepository
                .obtenerPorActivo(activo.idActivo!)
            : null;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),

          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFEAF0F6),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  _iconoCategoria(
                    activo.idCategoria,
                  ),
                  color: _primary,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Detalle del activo',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
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
                _tituloSeccion(
                  'Información general',
                  Icons.info_outline_rounded,
                ),

                _detalle(
                  'Serie',
                  activo.serie,
                ),
                _detalle(
                  'Marca',
                  activo.marca,
                ),
                _detalle(
                  'Modelo',
                  activo.modelo,
                ),
                _detalle(
                  'Estado',
                  activo.estado,
                ),
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

                // INFORMACIÓN TÉCNICA
                if (computadora != null) ...[
                  const Divider(height: 28),

                  _tituloSeccion(
                    'Información técnica',
                    Icons.memory_rounded,
                  ),

                  _detalle(
                    'Tipo',
                    computadora
                            .tipoComputadora ??
                        'Sin información',
                  ),
                  _detalle(
                    'Procesador',
                    computadora.procesador ??
                        'Sin información',
                  ),
                  _detalle(
                    'RAM',
                    computadora.ram ??
                        'Sin información',
                  ),
                  _detalle(
                    'Almacenamiento',
                    computadora
                            .almacenamiento ??
                        'Sin información',
                  ),
                  _detalle(
                    'Sistema operativo',
                    computadora
                            .sistemaOperativo ??
                        'Sin información',
                  ),
                  _detalle(
                    'Hostname',
                    computadora.hostname ??
                        'Sin información',
                  ),
                ],

                // ASIGNACIÓN
                if (asignacion != null) ...[
                  const Divider(height: 28),

                  _tituloSeccion(
                    'Información de asignación',
                    Icons
                        .assignment_ind_outlined,
                  ),

                  _detalle(
                    'Nombres',
                    asignacion.nombres
                                ?.isNotEmpty ==
                            true
                        ? asignacion.nombres!
                        : 'Sin información',
                  ),

                  _detalle(
                    'Apellidos',
                    asignacion.apellidos
                                ?.isNotEmpty ==
                            true
                        ? asignacion.apellidos!
                        : 'Sin información',
                  ),

                  _detalle(
                    'Cargo',
                    asignacion.cargo
                                ?.isNotEmpty ==
                            true
                        ? asignacion.cargo!
                        : 'Sin información',
                  ),

                  _detalle(
                    'Área',
                    asignacion.area
                                ?.isNotEmpty ==
                            true
                        ? asignacion.area!
                        : 'Sin información',
                  ),

                  _detalle(
                    'N.º de acta',
                    asignacion.numeroActa
                                ?.isNotEmpty ==
                            true
                        ? asignacion.numeroActa!
                        : 'Sin información',
                  ),

                  _detalle(
                    'Fecha asignación',
                    asignacion.fechaAsignacion
                                ?.isNotEmpty ==
                            true
                        ? asignacion
                            .fechaAsignacion!
                        : 'Sin información',
                  ),

                  _detalle(
                    'Responsable TIC',
                    asignacion.responsableTI
                                ?.isNotEmpty ==
                            true
                        ? asignacion
                            .responsableTI!
                        : 'Sin información',
                  ),
                ],

                const Divider(height: 28),

                _tituloSeccion(
                  'Observaciones',
                  Icons.notes_rounded,
                ),

                Text(
                  activo.observaciones
                              ?.isNotEmpty ==
                          true
                      ? activo.observaciones!
                      : 'Sin observaciones',
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
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

  Widget _tituloSeccion(
    String titulo,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: _primary,
            size: 19,
          ),
          const SizedBox(width: 8),
          Text(
            titulo,
            style: const TextStyle(
              color: _primary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detalle(
    String titulo,
    String valor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
            child: Text(
              titulo,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _estadoVacio() {
    return const Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_alt_off_outlined,
            size: 60,
            color: _primary,
          ),
          SizedBox(height: 15),
          Text(
            'No existen resultados',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Modifica los filtros para realizar otra consulta',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

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
      onPressed:
          enabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: _primary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: iconRight
            ? children.reversed.toList()
            : children,
      ),
    );
  }

  IconData _iconoCategoria(
    int idCategoria,
  ) {
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
        return Icons.inventory_2_rounded;
    }
  }

  int _obtenerIdCategoria(
    String categoria,
  ) {
    switch (categoria) {
      case 'Computadora':
        return 1;
      case 'Impresora':
        return 2;
      case 'Celular':
        return 3;
      case 'Radio':
        return 4;
      default:
        return 0;
    }
  }
}