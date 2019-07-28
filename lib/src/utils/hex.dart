import 'package:lib_colors/lib_colors.dart';

abstract class HexColorCodec {
  static final RegExp longRegExp = RegExp(
      r'\#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})(?:([0-9a-f]{2}))?',
      caseSensitive: false);
  static final RegExp shortRegExp = RegExp(
      r'\#?([0-9a-f])([0-9a-f])([0-9a-f])(?:([0-9a-f]))?',
      caseSensitive: false);

  /// Convert the color as a string in the format '#FF0F00', '#FFFF0F00', '#FF0'
  /// or '#FFF0' (with or without a leading '#', case insensitive) to the
  /// corresponding color value and store it in [result]. The first group is
  /// treated as the alpha channel if a [value] with four groups is passed.
  static Rgb decode(String value) {
    final Match longMatch = longRegExp.matchAsPrefix(value);

    if (longMatch != null) {
      final int r = int.parse(longMatch[1], radix: 16);
      final int g = int.parse(longMatch[2], radix: 16);
      final int b = int.parse(longMatch[3], radix: 16);
      int a = 255;

      if (longMatch[4] != null) {
        a = int.parse(longMatch[4], radix: 16);
      }

      return Rgb(r: r, g: g, b: b, a: a / 255);
    }

    final Match smallMatch = shortRegExp.matchAsPrefix(value);

    if (smallMatch != null) {
      final int r = int.parse(smallMatch[1] + smallMatch[1], radix: 16);
      final int g = int.parse(smallMatch[2] + smallMatch[2], radix: 16);
      final int b = int.parse(smallMatch[3] + smallMatch[3], radix: 16);
      int a = 255;

      if (smallMatch[4] != null) {
        a = int.parse(smallMatch[4] + smallMatch[4], radix: 16);
      }

      return Rgb(r: r, g: g, b: b, a: a / 255);
    }

    throw FormatException('Invalid hex color: $value');
  }

  static String encode(Color color,
      {bool shorten = true, bool withAlpha = true}) {
    final rgb = color.toRgb;

    int alpha = (rgb.a * 255).floor();

    final bool isShort = shorten &&
        ((rgb.r >> 4) == (rgb.r & 0xF)) &&
        ((rgb.g >> 4) == (rgb.g & 0xF)) &&
        ((rgb.b >> 4) == (rgb.b & 0xF)) &&
        (!withAlpha || (alpha >> 4) == (alpha & 0xF));

    if (isShort) {
      final String rgbStr = (rgb.r & 0xF).toRadixString(16) +
          (rgb.g & 0xF).toRadixString(16) +
          (rgb.b & 0xF).toRadixString(16);

      return "#$rgbStr" + (withAlpha ? (alpha & 0xF).toRadixString(16) : "");
    } else {
      final String rgbStr = rgb.r.toRadixString(16).padLeft(2, '0') +
          rgb.g.toRadixString(16).padLeft(2, '0') +
          rgb.b.toRadixString(16).padLeft(2, '0');

      return "#$rgbStr" +
          (withAlpha ? alpha.toRadixString(16).padLeft(2, '0') : "");
    }
  }
}
