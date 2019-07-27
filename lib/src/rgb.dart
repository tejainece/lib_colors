import 'dart:math';

import 'package:lib_colors/src/hsv.dart';
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

  Rgb clone({int r, int g, int b, num a}) =>
      Rgb(r: r ?? this.r, g: g ?? this.g, b: b ?? this.b, a: a ?? this.a);

  void assignRgb(Rgb rgb) {
    this.r = rgb.r;
    this.g = rgb.g;
    this.b = rgb.b;
    this.a = rgb.a;
  }

  void assignHsl(Hsl hsl) {
    assignRgb(hsl.toRgb);
  }

  double get brightness => (r * 299 + g * 587 + b * 114) / 1000;

  bool get isDark => brightness < 128.0;

  bool get isLight => !this.isDark;

  void brighten({num percent = 10}) {
    final term = (-(255 * percent / 100)).round();

    r = max(0, min(255, r - term));
    g = max(0, min(255, g - term));
    b = max(0, min(255, b - term));
  }

  void lighten({num percent = 10}) {
    assignHsl(toHsl..lighten(percent: percent));
  }

  void darken({num percent = 10}) {
    assignHsl(toHsl..darken(percent: percent));
  }

  void mix(Color withColor, {num percent = 50}) {
    final int p = (percent / 100).round();

    final withRgb = withColor.toRgb;
    a = (withRgb.a - a) * p + a;
    r = (withRgb.r - r) * p + r;
    g = (withRgb.g - g) * p + g;
    b = (withRgb.b - b) * p + b;
  }

  void tint({num percent = 10}) {
    this.mix(white, percent: percent);
  }

  void shade({num percent = 10}) {
    this.mix(black, percent: percent);
  }

  void desaturate({num percent = 10}) {
    assignHsl(toHsl..desaturate(percent: percent));
  }

  void saturate({num percent = 10}) {
    assignHsl(toHsl..saturate(percent: percent));
  }

  void greyscale() {
    assignHsl(toHsl..s = 0);
  }

  void spin(num degree) {
    assignHsl(toHsl..spin(degree));
  }

  void complement() {
    assignHsl(toHsl..complement());
  }

  Rgb get toRgb => clone();

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

  Hsv get toHsv {
    final int max_ = max(max(r, g), b);
    final int min_ = min(min(r, g), b);
    final int d = max_ - min_;
    final int v = max_;
    final double s = max_ == 0 ? 0 : d / max_;
    double h = 0.0;

    if (max_ != min_) {
      if (max_ == r) {
        h = (g - b) / d + (g < b ? 6.0 : 0.0);
      } else if (max_ == g) {
        h = (b - r) / d + 2.0;
      } else {
        h = (r - g) / d + 4.0;
      }

      h /= 6.0;
    }

    return Hsv(h: h, s: s, v: v, a: a);
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
