import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/activo.dart';
import '../../providers/activo_provider.dart';
import '../../providers/categoria_provider.dart';
import '../../models/computadora.dart';
import '../../repositories/computadora_repository.dart';
import '../../models/asignacion.dart';
import '../../repositories/asignacion_repository.dart';

class NuevoActivoScreen extends ConsumerStatefulWidget {
  final Activo? activo;

  const NuevoActivoScreen({
    super.key,
    this.activo,
  });

  @override
  ConsumerState<NuevoActivoScreen> createState() =>
      _NuevoActivoScreenState();
}

class _NuevoActivoScreenState extends ConsumerState<NuevoActivoScreen> {
  final _formKey = GlobalKey<FormState>();

  int? idCategoria;
  String? nombreCategoria;

  String? marcaSeleccionada;
  String? modeloSeleccionado;
  String? modeloPersonalizado;

  String tipoComputadoraSeleccionado = 'Laptop';
  String estadoSeleccionado = 'Almacén TIC';
  String condicionSeleccionada = 'Bueno';
  String ubicacionSeleccionada = 'Oficina Central';

  final serieController = TextEditingController();
  final otroModeloController = TextEditingController();
  final otraMarcaController = TextEditingController();
  final observacionesController = TextEditingController();
  final procesadorController = TextEditingController();
  final ramController = TextEditingController();
  final almacenamientoController = TextEditingController();
  final sistemaOperativoController = TextEditingController();
  final hostnameController = TextEditingController();
  final numeroActaController = TextEditingController();
  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  final cargoController = TextEditingController();
  final areaController = TextEditingController();
  
  String? responsableTISeleccionado;

  final otroSistemaOperativoController = TextEditingController();

  String sistemaOperativoSeleccionado = 'Windows 11';
  String ramSeleccionada = '16 GB';
  String almacenamientoSeleccionado = '256 GB SSD';

  DateTime fechaAsignacionSeleccionada = DateTime.now();

  final List<String> responsablesTI = [
    'Paola Balboa',
    'Nino Bustillos',
    'Daniel Pandique',
  ];

  final List<String> sistemasOperativos = [
    'Windows 10',
    'Windows 11',
    'Linux',
    'Otro',
  ];

  final List<String> opcionesRam = [
    '4 GB',
    '8 GB',
    '16 GB',
    '32 GB',
    '64 GB',
    'Otro',
  ];

  final List<String> opcionesAlmacenamiento = [
    '128 GB SSD',
    '256 GB SSD',
    '512 GB SSD',
    '1 TB SSD',
    '500 GB HDD',
    '1 TB HDD',
    'Otro',
  ];

  final List<String> procesadores = [
    'Intel(R) Core(TM) i3-8130U CPU @ 2.20GHz',
    'Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz',
    'Intel(R) Core(TM) i5-8265U CPU @ 1.60GHz',
    'Intel(R) Core(TM) i5-8365U CPU @ 1.60GHz',
    'Intel(R) Core(TM) i7-8550U CPU @ 1.80GHz',
    'Intel(R) Core(TM) i7-8565U CPU @ 1.80GHz',
    'Intel(R) Core(TM) i7-8665U CPU @ 1.90GHz',

    'Intel(R) Core(TM) i5-10210U CPU @ 1.60GHz',
    'Intel(R) Core(TM) i7-10510U CPU @ 1.80GHz',

    '11th Gen Intel(R) Core(TM) i5-1135G7 @ 2.40GHz',
    '11th Gen Intel(R) Core(TM) i7-1165G7 @ 2.80GHz',

    '12th Gen Intel(R) Core(TM) i3-1215U @ 1.20GHz',
    '12th Gen Intel(R) Core(TM) i5-1235U @ 1.30GHz',
    '12th Gen Intel(R) Core(TM) i5-1245U @ 1.60GHz',
    '12th Gen Intel(R) Core(TM) i7-1255U @ 1.70GHz',
    '12th Gen Intel(R) Core(TM) i7-1265U @ 1.80GHz',

    '13th Gen Intel(R) Core(TM) i3-1315U @ 1.20GHz',
    '13th Gen Intel(R) Core(TM) i5-1335U @ 1.30GHz',
    '13th Gen Intel(R) Core(TM) i5-1345U @ 1.60GHz',
    '13th Gen Intel(R) Core(TM) i7-1355U @ 1.70GHz',
  ];

  final List<String> estados = [
    'Almacén TIC',
    'Asignado',
    'En mantenimiento',
  ];

  final List<String> condiciones = [
    'Nuevo',
    'Bueno',
    'Mal estado',
  ];

  final List<String> ubicaciones = [
    'Oficina Central',
    'Zongo',
    'Miguillas',
  ];

  final List<String> tiposComputadora = [
    'Laptop',
    'Desktop',
  ];

  final Map<String, List<String>> modelosComputadora = {
    'Lenovo': [
      'ThinkPad L14',
      'ThinkPad L14 Gen 2',
      'ThinkPad L14 Gen 3',
      'ThinkPad L14 Gen 4',
      'ThinkPad L14 Gen 5',
      'ThinkPad E14',
      'ThinkPad E14 Gen 2',
      'ThinkPad E14 Gen 3',
      'ThinkPad E14 Gen 4',
      'ThinkPad E14 Gen 5',
      'ThinkPad L440',
      'ThinkPad L460',
      'ThinkPad L480',
      'ThinkPad L490',
      'ThinkPad X1 Carbon',
      'ThinkCentre M720q',
      'ThinkCentre M70s Gen 3',
      'Otro',
    ],
    'Dell': [
      'Latitude 3550',
      'Otro',
    ],
    'Otro': [
      'Otro',
    ],
  };

  @override
  void initState() {
    super.initState();

    final activo = widget.activo;

    if (activo != null) {
      idCategoria = activo.idCategoria;
      serieController.text = activo.serie;
      estadoSeleccionado = activo.estado;
      observacionesController.text = activo.observaciones ?? '';

      if (condiciones.contains(activo.condicionFisica)) {
        condicionSeleccionada = activo.condicionFisica!;
      }

      if (ubicaciones.contains(activo.ubicacion)) {
        ubicacionSeleccionada = activo.ubicacion!;
      }

      if (modelosComputadora.containsKey(activo.marca)) {
        marcaSeleccionada = activo.marca;

        final modelos = modelosComputadora[activo.marca]!;

        if (modelos.contains(activo.modelo)) {
          modeloSeleccionado = activo.modelo;
        } else {
          modeloSeleccionado = 'Otro';
          otroModeloController.text = activo.modelo;
        }
      } else {
        marcaSeleccionada = 'Otro';
        otraMarcaController.text = activo.marca;
        modeloSeleccionado = 'Otro';
        otroModeloController.text = activo.modelo;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatosEspecificos();
    });
  }

  Future<void> _cargarDatosEspecificos() async {
    final activo = widget.activo;

    if (activo == null || activo.idActivo == null) {
      return;
    }

    if (activo.idCategoria == 1) {
      final computadoraRepository = ComputadoraRepository();

      final computadora =
          await computadoraRepository.obtenerPorActivo(activo.idActivo!);

          debugPrint('COMPUTADORA ENCONTRADA: ${computadora?.toMap()}');

      if (computadora != null && mounted) {
        setState(() {
          tipoComputadoraSeleccionado =
              computadora.tipoComputadora ?? 'Laptop';

          procesadorController.text =
              computadora.procesador ?? '';

          ramSeleccionada =
              computadora.ram ?? '16 GB';

          almacenamientoSeleccionado =
              computadora.almacenamiento ?? '256 GB SSD';

          sistemaOperativoSeleccionado =
              computadora.sistemaOperativo ?? 'Windows 11';

          hostnameController.text =
              computadora.hostname ?? '';
        });
      }
    }

    final asignacionRepository = AsignacionRepository();

    final asignacion =
        await asignacionRepository.obtenerPorActivo(activo.idActivo!);

        debugPrint('ID ACTIVO: ${activo.idActivo}');
        debugPrint('ASIGNACION ENCONTRADA: ${asignacion?.toMap()}');

    if (asignacion != null && mounted) {
      setState(() {
        numeroActaController.text =
            asignacion.numeroActa ?? '';

        nombresController.text =
            asignacion.nombres ?? '';

        apellidosController.text =
            asignacion.apellidos ?? '';

        cargoController.text =
            asignacion.cargo ?? '';

        areaController.text =
            asignacion.area ?? '';

        responsableTISeleccionado =
            asignacion.responsableTI;

        if (asignacion.fechaAsignacion != null &&
            asignacion.fechaAsignacion!.isNotEmpty) {
          fechaAsignacionSeleccionada =
              DateTime.tryParse(asignacion.fechaAsignacion!) ??
              DateTime.now();
        }
      });
    }
  }

  @override
  void dispose() {
    serieController.dispose();
    otroModeloController.dispose();
    otraMarcaController.dispose();
    observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriasAsync = ref.watch(categoriasProvider);

    const primary = Color(0xFF173A5E);
    const secondary = Color(0xFF2D5F8B);
    const background = Color(0xFFF4F6F9);
    const textPrimary = Color(0xFF1F2937);
    const textSecondary = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: background,
      body: categoriasAsync.when(
        data: (categorias) {
          if (idCategoria != null && nombreCategoria == null) {
            for (final categoria in categorias) {
              if (categoria.idCategoria == idCategoria) {
                nombreCategoria = categoria.nombre;
                break;
              }
            }
          }

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
                      primary,
                      secondary,
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
                      24,
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
                            Text(
                              widget.activo == null
                                  ? 'Nuevo activo'
                                  : 'Editar activo',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            top: 8,
                          ),
                          child: Text(
                            widget.activo == null
                                ? 'Registra un nuevo activo tecnológico'
                                : 'Actualiza la información del activo',
                            style: const TextStyle(
                              color: Color(0xFFD9E6F2),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ============================================
              // FORMULARIO
              // ============================================
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    22,
                    18,
                    30,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ========================================
                        // INFORMACIÓN GENERAL
                        // ========================================
                        _seccionFormulario(
                          titulo: 'Información general',
                          subtitulo:
                              'Datos principales de identificación del activo',
                          icono: Icons.inventory_2_outlined,
                          child: Column(
                            children: [
                              DropdownButtonFormField<int>(
                                initialValue: idCategoria,
                                isExpanded: true,
                                decoration: _decoracionCampo(
                                  'Categoría',
                                  Icons.category_outlined,
                                ),
                                items: categorias.map((categoria) {
                                  return DropdownMenuItem<int>(
                                    value: categoria.idCategoria,
                                    child: Text(categoria.nombre),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  final categoria =
                                      categorias.firstWhere(
                                    (item) =>
                                        item.idCategoria == value,
                                  );

                                  setState(() {
                                    idCategoria = value;
                                    nombreCategoria =
                                        categoria.nombre;

                                    marcaSeleccionada = null;
                                    modeloSeleccionado = null;

                                    otraMarcaController.clear();
                                    otroModeloController.clear();
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleccione una categoría';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 14),

                              if (nombreCategoria ==
                                  'Computadora') ...[
                                _crearDropdown(
                                  label: 'Tipo de computadora',
                                  value:
                                      tipoComputadoraSeleccionado,
                                  items: tiposComputadora,
                                  onChanged: (value) {
                                    setState(() {
                                      tipoComputadoraSeleccionado =
                                          value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 14),
                              ],

                              _crearCampo(
                                label: 'Serie',
                                controller: serieController,
                              ),

                              if (nombreCategoria ==
                                  'Computadora') ...[
                                _crearDropdown(
                                  label: 'Marca',
                                  value: marcaSeleccionada,
                                  items: modelosComputadora.keys
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      marcaSeleccionada = value;
                                      modeloSeleccionado = null;

                                      otraMarcaController.clear();
                                      otroModeloController.clear();
                                    });
                                  },
                                ),

                                const SizedBox(height: 14),

                                if (marcaSeleccionada == 'Otro')
                                  _crearCampo(
                                    label: 'Especifique la marca',
                                    controller:
                                        otraMarcaController,
                                  ),

                                if (marcaSeleccionada != null) ...[
                                  _crearDropdown(
                                    label: 'Modelo',
                                    value: modeloSeleccionado,
                                    items: modelosComputadora[
                                        marcaSeleccionada]!,
                                    onChanged: (value) {
                                      setState(() {
                                        modeloSeleccionado = value;

                                        if (value != 'Otro') {
                                          otroModeloController
                                              .clear();
                                        }
                                      });
                                    },
                                  ),

                                  const SizedBox(height: 14),
                                ],

                                if (modeloSeleccionado == 'Otro')
                                  _crearCampo(
                                    label:
                                        'Especifique el modelo',
                                    controller:
                                        otroModeloController,
                                  ),
                              ] else ...[
                                _crearCampo(
                                  label: 'Marca',
                                  controller:
                                      otraMarcaController,
                                ),
                                _crearCampo(
                                  label: 'Modelo',
                                  controller:
                                      otroModeloController,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // ========================================
                        // INFORMACIÓN TÉCNICA
                        // ========================================
                        if (nombreCategoria ==
                            'Computadora') ...[
                          const SizedBox(height: 18),

                          _seccionFormulario(
                            titulo: 'Especificaciones técnicas',
                            subtitulo:
                                'Características de hardware y sistema',
                            icono: Icons.memory_rounded,
                            child: Column(
                              children: [
                                Autocomplete<String>(
                                  optionsBuilder: (
                                    TextEditingValue
                                        textEditingValue,
                                  ) {
                                    if (textEditingValue
                                        .text.isEmpty) {
                                      return const Iterable<
                                          String>.empty();
                                    }

                                    return procesadores.where(
                                      (procesador) {
                                        return procesador
                                            .toLowerCase()
                                            .contains(
                                              textEditingValue
                                                  .text
                                                  .toLowerCase(),
                                            );
                                      },
                                    );
                                  },
                                  onSelected:
                                      (String seleccion) {
                                    procesadorController.text =
                                        seleccion;
                                  },
                                  fieldViewBuilder: (
                                    context,
                                    textEditingController,
                                    focusNode,
                                    onFieldSubmitted,
                                  ) {
                                    if (procesadorController
                                            .text.isNotEmpty &&
                                        textEditingController
                                            .text.isEmpty) {
                                      textEditingController.text =
                                          procesadorController
                                              .text;
                                    }

                                    return TextFormField(
                                      controller:
                                          textEditingController,
                                      focusNode: focusNode,
                                      decoration:
                                          _decoracionCampo(
                                        'Procesador',
                                        Icons.memory_rounded,
                                        hint:
                                            'Ejemplo: i5, i7, Ryzen 5...',
                                      ),
                                      onChanged: (value) {
                                        procesadorController.text =
                                            value;
                                      },
                                      validator: (value) {
                                        if (value == null ||
                                            value
                                                .trim()
                                                .isEmpty) {
                                          return 'Campo requerido';
                                        }
                                        return null;
                                      },
                                    );
                                  },
                                ),

                                const SizedBox(height: 14),

                                _crearDropdown(
                                  label: 'RAM',
                                  value: ramSeleccionada,
                                  items: opcionesRam,
                                  onChanged: (value) {
                                    setState(() {
                                      ramSeleccionada = value!;
                                    });
                                  },
                                ),

                                const SizedBox(height: 14),

                                _crearDropdown(
                                  label: 'Almacenamiento',
                                  value:
                                      almacenamientoSeleccionado,
                                  items:
                                      opcionesAlmacenamiento,
                                  onChanged: (value) {
                                    setState(() {
                                      almacenamientoSeleccionado =
                                          value!;
                                    });
                                  },
                                ),

                                const SizedBox(height: 14),

                                _crearDropdown(
                                  label: 'Sistema Operativo',
                                  value:
                                      sistemaOperativoSeleccionado,
                                  items: sistemasOperativos,
                                  onChanged: (value) {
                                    setState(() {
                                      sistemaOperativoSeleccionado =
                                          value!;
                                    });
                                  },
                                ),

                                const SizedBox(height: 14),

                                if (sistemaOperativoSeleccionado ==
                                    'Otro')
                                  _crearCampo(
                                    label:
                                        'Especifique el sistema operativo',
                                    controller:
                                        otroSistemaOperativoController,
                                  ),

                                _crearCampo(
                                  label: 'Hostname',
                                  controller:
                                      hostnameController,
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 18),

                        // ========================================
                        // ESTADO Y UBICACIÓN
                        // ========================================
                        _seccionFormulario(
                          titulo: 'Estado y ubicación',
                          subtitulo:
                              'Situación actual y localización del activo',
                          icono: Icons.location_on_outlined,
                          child: Column(
                            children: [
                              _crearDropdown(
                                label: 'Estado',
                                value: estadoSeleccionado,
                                items: estados,
                                onChanged: (value) {
                                  setState(() {
                                    estadoSeleccionado = value!;
                                  });
                                },
                              ),

                              const SizedBox(height: 14),

                              _crearDropdown(
                                label: 'Condición física',
                                value: condicionSeleccionada,
                                items: condiciones,
                                onChanged: (value) {
                                  setState(() {
                                    condicionSeleccionada =
                                        value!;
                                  });
                                },
                              ),

                              const SizedBox(height: 14),

                              _crearDropdown(
                                label: 'Ubicación',
                                value: ubicacionSeleccionada,
                                items: ubicaciones,
                                onChanged: (value) {
                                  setState(() {
                                    ubicacionSeleccionada =
                                        value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        // ========================================
                        // DATOS DE ASIGNACIÓN
                        // ========================================
                        if (estadoSeleccionado ==
                            'Asignado') ...[
                          const SizedBox(height: 18),

                          _seccionFormulario(
                            titulo: 'Datos de asignación',
                            subtitulo:
                                'Información del responsable del activo',
                            icono:
                                Icons.assignment_ind_outlined,
                            child: Column(
                              children: [
                                _crearCampo(
                                  label: 'N.º de acta',
                                  controller:
                                      numeroActaController,
                                ),

                                _crearCampo(
                                  label: 'Nombres',
                                  controller:
                                      nombresController,
                                ),

                                _crearCampo(
                                  label: 'Apellidos',
                                  controller:
                                      apellidosController,
                                ),

                                _crearCampo(
                                  label: 'Cargo',
                                  controller:
                                      cargoController,
                                ),

                                _crearCampo(
                                  label: 'Área',
                                  controller:
                                      areaController,
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color(0xFFF9FAFB),
                                    borderRadius:
                                        BorderRadius.circular(
                                      12,
                                    ),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFD1D5DB,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons
                                          .calendar_month_outlined,
                                      color: primary,
                                    ),
                                    title: const Text(
                                      'Fecha de asignación',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textSecondary,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${fechaAsignacionSeleccionada.day.toString().padLeft(2, '0')}/'
                                      '${fechaAsignacionSeleccionada.month.toString().padLeft(2, '0')}/'
                                      '${fechaAsignacionSeleccionada.year}',
                                      style: const TextStyle(
                                        color: textPrimary,
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w500,
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons
                                          .chevron_right_rounded,
                                      color: secondary,
                                    ),
                                    onTap: () async {
                                      final fecha =
                                          await showDatePicker(
                                        context: context,
                                        initialDate:
                                            fechaAsignacionSeleccionada,
                                        firstDate:
                                            DateTime(2020),
                                        lastDate:
                                            DateTime(2100),
                                      );

                                      if (fecha != null) {
                                        setState(() {
                                          fechaAsignacionSeleccionada =
                                              fecha;
                                        });
                                      }
                                    },
                                  ),
                                ),

                                const SizedBox(height: 14),

                                _crearDropdown(
                                  label: 'Responsable TIC',
                                  value:
                                      responsableTISeleccionado,
                                  items: responsablesTI,
                                  onChanged: (value) {
                                    setState(() {
                                      responsableTISeleccionado =
                                          value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 18),

                        // ========================================
                        // OBSERVACIONES
                        // ========================================
                        _seccionFormulario(
                          titulo: 'Observaciones',
                          subtitulo:
                              'Información adicional relevante',
                          icono: Icons.notes_rounded,
                          child: TextFormField(
                            controller:
                                observacionesController,
                            maxLines: 4,
                            decoration: _decoracionCampo(
                              'Observaciones',
                              Icons.edit_note_rounded,
                              hint:
                                  'Ingrese información adicional del activo',
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ========================================
                        // BOTÓN GUARDAR
                        // ========================================
                        SizedBox(
                          height: 54,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: guardar,
                            icon: const Icon(
                              Icons.save_outlined,
                            ),
                            label: Text(
                              widget.activo == null
                                  ? 'Registrar activo'
                                  : 'Guardar cambios',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },

        loading: () => const Center(
          child: CircularProgressIndicator(
            color: primary,
          ),
        ),

        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _seccionFormulario({
  required String titulo,
  required String subtitulo,
  required IconData icono,
  required Widget child,
}) {
  const primary = Color(0xFF173A5E);
  const textPrimary = Color(0xFF1F2937);
  const textSecondary = Color(0xFF6B7280);

  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: const Color(0xFFE5E7EB),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.025),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icono,
                color: primary,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        child,
      ],
    ),
  );
}

InputDecoration _decoracionCampo(
  String label,
  IconData icono, {
  String? hint,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: Icon(
      icono,
      color: const Color(0xFF2D5F8B),
      size: 21,
    ),
    filled: true,
    fillColor: const Color(0xFFF9FAFB),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFFD1D5DB),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFFD1D5DB),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFF2D5F8B),
        width: 1.5,
      ),
    ),
  );
}

  Widget _crearCampo({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Campo requerido';
          }

          return null;
        },
      ),
    );
  }

  Widget _crearDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: items.contains(value) ? value : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Seleccione una opción';
        }

        return null;
      },
    );
  }

    Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final activoRepository = ref.read(activoRepositoryProvider);
    final computadoraRepository = ComputadoraRepository();
    final asignacionRepository = AsignacionRepository();

    String marcaFinal;
    String modeloFinal;

    if (nombreCategoria == 'Computadora') {
      marcaFinal = marcaSeleccionada == 'Otro'
          ? otraMarcaController.text.trim()
          : marcaSeleccionada ?? '';

      modeloFinal = modeloSeleccionado == 'Otro'
          ? otroModeloController.text.trim()
          : modeloSeleccionado ?? '';
    } else {
      marcaFinal = otraMarcaController.text.trim();
      modeloFinal = otroModeloController.text.trim();
    }

    final activo = Activo(
      idActivo: widget.activo?.idActivo,
      idCategoria: idCategoria!,
      serie: serieController.text.trim(),
      marca: marcaFinal,
      modelo: modeloFinal,
      estado: estadoSeleccionado,
      condicionFisica: condicionSeleccionada,
      ubicacion: ubicacionSeleccionada,
      observaciones: observacionesController.text.trim(),
      fechaRegistro:
          widget.activo?.fechaRegistro ?? DateTime.now().toIso8601String(),
    );

    try {
      int idActivo;

      // Guardar o actualizar los datos generales del activo
      if (widget.activo == null) {
        idActivo = await activoRepository.insertarActivo(activo);
      } else {
        idActivo = widget.activo!.idActivo!;

        await activoRepository.actualizarActivo(activo);
      }

      // Guardar o actualizar los datos específicos de computadora
      if (nombreCategoria == 'Computadora') {
        final sistemaOperativoFinal =
            sistemaOperativoSeleccionado == 'Otro'
                ? otroSistemaOperativoController.text.trim()
                : sistemaOperativoSeleccionado;

        final computadora = Computadora(
          idActivo: idActivo,
          tipoComputadora: tipoComputadoraSeleccionado,
          procesador: procesadorController.text.trim(),
          ram: ramSeleccionada,
          almacenamiento: almacenamientoSeleccionado,
          sistemaOperativo: sistemaOperativoFinal,
          hostname: hostnameController.text.trim(),
        );

        final computadoraExistente =
            await computadoraRepository.obtenerPorActivo(idActivo);

        if (computadoraExistente == null) {
          await computadoraRepository.insertarComputadora(
            computadora,
          );
        } else {
          await computadoraRepository.actualizarComputadora(
            computadora,
          );
        }
      }

      if (estadoSeleccionado == 'Asignado') {
        final asignacion = Asignacion(
          idActivo: idActivo,
          numeroActa: numeroActaController.text.trim(),
          nombres: nombresController.text.trim(),
          apellidos: apellidosController.text.trim(),
          cargo: cargoController.text.trim(),
          area: areaController.text.trim(),
          fechaAsignacion: fechaAsignacionSeleccionada.toIso8601String(),
          responsableTI: responsableTISeleccionado,
        );

        final asignacionExistente =
            await asignacionRepository.obtenerPorActivo(idActivo);

        if (asignacionExistente == null) {
          await asignacionRepository.insertarAsignacion(asignacion);
        } else {
          await asignacionRepository.actualizarAsignacion(asignacion);
        }
      }

      ref.invalidate(activosProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.activo == null
                ? 'Activo registrado correctamente'
                : 'Activo actualizado correctamente',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      final mensajeError = e.toString().toLowerCase();

      if (mensajeError.contains('unique') ||
          mensajeError.contains('serie')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ya existe un activo registrado con la serie '
              '${serieController.text.trim()}.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se pudo guardar el activo. Error: $e',
            ),
          ),
        );
      }
    }
  }
}