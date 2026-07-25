import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/activo_provider.dart';
import '../asignaciones/asignaciones_screen.dart';
import '../inventario/inventario_screen.dart';
import '../reportes/reportes_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const Color _primary = Color(0xFF173A5E);
  static const Color _secondary = Color(0xFF2D5F8B);
  static const Color _background = Color(0xFFF4F6F9);
  static const Color _textPrimary = Color(0xFF1F2937);
  static const Color _textSecondary = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activosAsync = ref.watch(activosProvider);

    return Scaffold(
      backgroundColor: _background,
      body: activosAsync.when(
        data: (activos) {
          final total = activos.length;

          final asignados = activos
              .where((activo) => activo.estado == 'Asignado')
              .length;

          final disponibles = activos
              .where(
                (activo) =>
                    activo.estado == 'Almacén TIC' ||
                    activo.estado == 'Disponible',
              )
              .length;

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ==========================================
                  // ENCABEZADO PRINCIPAL
                  // ==========================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      28,
                      24,
                      32,
                    ),
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
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LOGO + NOMBRE
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TechInventory Pro',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Sistema de Gestión de Activos Tecnológicos',
                                    style: TextStyle(
                                      color: Color(0xFFD9E6F2),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          'Panel de control',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 7),

                        const Text(
                          'Resumen general del inventario tecnológico',
                          style: TextStyle(
                            color: Color(0xFFD9E6F2),
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // MÉTRICAS
                        Row(
                          children: [
                            Expanded(
                              child: _headerMetric(
                                icon: Icons.devices_outlined,
                                value: total,
                                label: 'Total',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _headerMetric(
                                icon:
                                    Icons.assignment_ind_outlined,
                                value: asignados,
                                label: 'Asignados',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _headerMetric(
                                icon: Icons.inventory_outlined,
                                value: disponibles,
                                label: 'Disponibles',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ==========================================
                  // CONTENIDO
                  // ==========================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      26,
                      20,
                      10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Módulos principales',
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          'Selecciona una opción para gestionar la información',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // INVENTARIO
                        _moduleCard(
                          icon: Icons.inventory_2_outlined,
                          title: 'Inventario',
                          subtitle:
                              'Registro y administración de activos',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const InventarioScreen(),
                              ),
                            );
                          },
                        ),

                        // ASIGNACIONES
                        _moduleCard(
                          icon:
                              Icons.assignment_ind_outlined,
                          title: 'Asignaciones',
                          subtitle:
                              'Control de activos asignados al personal',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const AsignacionesScreen(),
                              ),
                            );
                          },
                        ),

                        // REPORTES
                        _moduleCard(
                          icon: Icons.analytics_outlined,
                          title: 'Reportes',
                          subtitle:
                              'Consulta y análisis del inventario',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ReportesScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // ==========================================
                        // INFORMACIÓN DEL SISTEMA
                        // ==========================================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: _primary,
                                size: 22,
                              ),
                              SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sistema de gestión',
                                      style: TextStyle(
                                        color: _textPrimary,
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Control centralizado de activos tecnológicos',
                                      style: TextStyle(
                                        color: _textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ==========================================
                        // AUTORÍA
                        // ==========================================
                        const Center(
                          child: Column(
                            children: [
                              Text(
                                'TechInventory Pro',
                                style: TextStyle(
                                  color: _textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Desarrollado por Paola Balboa',
                                style: TextStyle(
                                  color: _textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Proyecto académico · 2026',
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },

        loading: () => const Center(
          child: CircularProgressIndicator(
            color: _primary,
          ),
        ),

        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'No se pudo cargar la información.\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TARJETAS DE MÉTRICAS
  // ==========================================
  Widget _headerMetric({
    required IconData icon,
    required int value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),
          const SizedBox(height: 7),
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFD9E6F2),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TARJETAS DEL MENÚ
  // ==========================================
  Widget _moduleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.035,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF0F6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: _primary,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 12,
                          height: 1.3,
                        ),
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
                    Icons.arrow_forward_ios_rounded,
                    color: _secondary,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}