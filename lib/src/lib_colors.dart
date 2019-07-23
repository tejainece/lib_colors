import 'package:lib_colors/src/hsl.dart';
import 'package:lib_colors/src/rgb.dart';

abstract class Color {
  /// Returns CSS representation of the color
  String get css;

  /// Returns HEX representation of the color
  String hex({bool shorten = true, bool withAlpha = true});

  Rgb get toRgb;

  Hsl get toHsl;
}
