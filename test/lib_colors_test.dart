import 'package:lib_colors/lib_colors.dart';
import 'package:lib_colors/src/hsl.dart';
import 'package:lib_colors/src/rgb.dart';
import 'package:test/test.dart';

void main() {
  group('Rgb', () {
    test('Parse', () {
      expect(Rgb.parse('rgb(100, 5, 90)').css, 'rgba(100, 5, 90, 1)');
      expect(Rgb.parse('rgba(100, 100, 100, 0.5)').css,
          'rgba(100, 100, 100, 0.5)');
      expect(
          Rgb.parse('rgba(100, 100, 100, .5)').css, 'rgba(100, 100, 100, 0.5)');
      expect(
          Rgb.parse('rgba(100, 100, 100, 1)').css, 'rgba(100, 100, 100, 1)');
    });
  });
  group('Parse', () {
    test('First Test', () {
      expect(Hsl.parse('hsl(100, 99%, 50%)').css, 'hsl(100, 99%, 50%, 1)');
    });
  });
}
