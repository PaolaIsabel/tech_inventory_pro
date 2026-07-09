import 'package:flutter/material.dart';

class IconHelper {
  static IconData obtenerIcono(String? icono) {
    switch (icono) {
      case 'computer':
        return Icons.computer;

      case 'print':
        return Icons.print;

      case 'smartphone':
        return Icons.smartphone;

      case 'settings_input_antenna':
        return Icons.settings_input_antenna;

      case 'router':
        return Icons.router;

      case 'camera':
        return Icons.videocam;

      case 'inventory':
        return Icons.inventory_2;

      default:
        return Icons.devices;
    }
  }
}