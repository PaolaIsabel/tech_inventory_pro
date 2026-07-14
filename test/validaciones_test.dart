import 'package:flutter_test/flutter_test.dart';
import 'package:tech_inventory_pro/utils/validaciones.dart';

void main() {
  group('Validaciones', () {
    test('Acepta una serie válida', () {
      // Arrange
      const serie = 'LEN12345';

      // Act
      final resultado = Validaciones.serieValida(serie);

      // Assert
      expect(resultado, true);
    });

    test('Rechaza una serie vacía', () {
      // Arrange
      const serie = '';

      // Act
      final resultado = Validaciones.serieValida(serie);

      // Assert
      expect(resultado, false);
    });
  });
}