import 'dart:math';

import 'package:lib_colors/src/utils/num.dart';

import 'lib_colors.dart';
import 'hsl.dart';

class Rgb implements Color {
  int _r;

  int _g;

  int _b;

  double _a;

  Rgb({int r = 0, int g = 0, int b = 0, num a = 1.0}) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
  }

  factory Rgb.parse(String css) {
    if (css.startsWith('rgba')) {
      Match match = rgbaRegExp.matchAsPrefix(css);
      if (match == null) throw FormatException("Invalid value!");

      int r = int.tryParse(match[1]);
      if (r == null) throw FormatException("Invalid red compenent!");
      int g = int.tryParse(match[2]);
      if (g == null) throw FormatException("Invalid green compenent!");
      int b = int.tryParse(match[3]);
      if (b == null) throw FormatException("Invalid blue compenent!");
      double a = double.tryParse(match[4] ?? match[5]);
      if (a == null) throw FormatException("Invalid alpha compenent!");
      return Rgb(r: r, g: g, b: b, a: a);
    }

    if (css.startsWith('rgb')) {
      Match match = rgbRegExp.matchAsPrefix(css);
      if (match == null) throw FormatException("Invalid value!");

      int r = int.tryParse(match[1]);
      if (r == null) throw FormatException("Invalid red compenent!");
      int g = int.tryParse(match[2]);
      if (g == null) throw FormatException("Invalid green compenent!");
      int b = int.tryParse(match[3]);
      if (b == null) throw FormatException("Invalid blue compenent!");
      return Rgb(r: r, g: g, b: b);
    }

    throw FormatException("Invalid value!");
  }

  int get r => _r;

  int get g => _g;

  int get b => _b;

  double get a => _a;

  set r(int v) {
    if (v < 0 || v > 255) throw ArgumentError.value(v);
    _r = v;
  }

  set g(int v) {
    if (v < 0 || v > 255) throw ArgumentError.value(v);
    _g = v;
  }

  set b(int v) {
    if (v < 0 || v > 255) throw ArgumentError.value(v);
    _b = v;
  }

  set a(num v) {
    if (v < 0 || v > 1.0) throw ArgumentError.value(v);
    _a = v.toDouble();
  }

  Rgb get toRgb => Rgb(r: r, g: g, b: b, a: a);

  Hsl get toHsl {
    num rf = r / 255;
    num gf = g / 255;
    num bf = b / 255;
    num cMax = [rf, gf, bf].reduce(max);
    num cMin = [rf, gf, bf].reduce(min);
    num delta = cMax - cMin;
    num hue;
    num saturation;
    num luminance;

    if (cMax == rf) {
      hue = 60 * ((gf - bf) / delta % 6);
    } else if (cMax == gf) {
      hue = 60 * ((bf - rf) / delta + 2);
    } else {
      hue = 60 * ((rf - gf) / delta + 4);
    }

    if (hue.isNaN || hue.isInfinite) {
      hue = 0;
    }

    luminance = (cMax + cMin) / 2;

    if (delta == 0) {
      saturation = 0;
    } else {
      saturation = delta / (1 - (luminance * 2 - 1).abs());
    }

    return Hsl(h: hue, s: saturation * 100, l: luminance * 100, a: a);
  }

  String get css => 'rgba($r, $g, $b, ${shortenDouble(a)})';

  String hex({bool shorten = true, bool withAlpha = true}) {
    int a = (this.a * 255).floor();

    final bool isShort = shorten &&
        ((r >> 4) == (r & 0xF)) &&
        ((g >> 4) == (g & 0xF)) &&
        ((b >> 4) == (b & 0xF)) &&
        (!withAlpha || (a >> 4) == (a & 0xF));

    if (isShort) {
      final String rgb = (r & 0xF).toRadixString(16) +
          (g & 0xF).toRadixString(16) +
          (b & 0xF).toRadixString(16);

      return withAlpha ? (a & 0xF).toRadixString(16) + rgb : rgb;
    } else {
      final String rgb = r.toRadixString(16).padLeft(2, '0') +
          g.toRadixString(16).padLeft(2, '0') +
          b.toRadixString(16).padLeft(2, '0');

      return withAlpha ? a.toRadixString(16).padLeft(2, '0') + rgb : rgb;
    }
  }

  String toString() => css;

  static final rgbRegExp =
      RegExp(r'rgb\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$');
  static final rgbaRegExp = RegExp(
      r'rgba\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d+(\.\d*)?|\.\d+)\s*\)$');
}