import 'package:lib_colors/lib_colors.dart';
import 'package:lib_colors/src/rgb.dart';
import 'package:lib_colors/src/hsl.dart';

class Hsv implements Color {
  double _h;

  double _s;

  double _v;

  double _a;

  Hsv({num h = 0, num s = 0, num v = 0, num a = 1.0}) {
    this.h = h;
    this.s = s;
    this.v = v;
    this.a = a;
  }

  num get h => _h;

  num get s => _s;

  num get v => _v;

  double get a => _a;

  double get opacity => a / 255;

  set h(num v) {
    if (v < hMin || v > hMax) throw ArgumentError.value(v);
    _h = v.toDouble();
  }

  set s(num v) {
    if (v < sMin || v > sMax) throw ArgumentError.value(v);
    _s = v.toDouble();
  }

  set v(num v) {
    if (vMin < 0 || v > vMax) throw ArgumentError.value(v);
    _v = v.toDouble();
  }

  set a(num v) {
    if (v < 0 || v > 1.0) throw ArgumentError.value(v);
    _a = v.toDouble();
  }

  void assignRgb(Rgb rgb) {
    assignHsv(rgb.toHsv);
  }

  void assignHsl(Hsl hsl) {
    assignHsv(hsl.toHsv);
  }

  void assignHsv(Hsv hsl) {
    a = hsl.a;
    h = hsl.h;
    s = hsl.s;
    v = hsl.v;
  }

  Hsv clone({num h, num s, num v, num a}) =>
      Hsv(h: h ?? this.h, s: s ?? this.s, v: v ?? this.v, a: a ?? this.a);

  bool get isDark => brightness < 128.0;

  bool get isLight => !this.isDark;

  double get brightness => toRgb.brightness;

  void brighten({num percent = 10}) {
    assignRgb(toRgb..brighten(percent: percent));
  }

  void lighten({num percent = 10}) {
    // TODO throw
    throw UnimplementedError();
  }

  void darken({num percent = 10}) {
    // TODO throw
    throw UnimplementedError();
  }

  void desaturate({num percent = 10}) {
    // TODO throw
    throw UnimplementedError();
  }

  void saturate({num percent = 10}) {
    // TODO throw
    throw UnimplementedError();
  }

  void greyscale() {
    // TODO throw
    throw UnimplementedError();
  }

  void spin(num degrees) {
    final hue = (h + degrees) % 360;
    h = hue < 0 ? 360 + hue : hue;
  }

  void complement() {
    h = (h + 180) % 360;
  }

  void mix(Color withColor, {num percent = 50}) {
    assignRgb(toRgb..mix(withColor, percent: percent));
  }

  void tint({num percent = 10}) {
    this.mix(white, percent: percent);
  }

  void shade({num percent = 10}) {
    this.mix(black, percent: percent);
  }

  Rgb get toRgb {
    final int i = (h * 6.0).floor();
    final double f = h * 6.0 - i.toDouble();
    final int p = ((v / 100 * (1.0 - s / 100)) * 255).toInt();
    final int q = ((v / 100 * (1.0 - f * s / 100)) * 255).toInt();
    final int t = ((v / 100 * (1.0 - (1.0 - f) * s / 100)) * 255).toInt();
    final int cmax = (v / 100 * 255).toInt();

    Rgb rgb;
    switch (i % 6) {
      case 0:
        rgb = Rgb(r: cmax, g: t, b: p, a: a);
        break;
      case 1:
        rgb = Rgb(r: q, g: cmax, b: p, a: a);
        break;
      case 2:
        rgb = Rgb(r: p, g: cmax, b: t, a: a);
        break;
      case 3:
        rgb = Rgb(r: p, g: q, b: cmax, a: a);
        break;
      case 4:
        rgb = Rgb(r: t, g: p, b: cmax, a: a);
        break;
      case 5:
        rgb = Rgb(r: cmax, g: p, b: q, a: a);
        break;
    }

    return rgb;
  }

  Hsv get toHsv => clone();

  Hsl get toHsl => toRgb.toHsl;

  String get css => toRgb.css;

  String hex({bool shorten = true, bool withAlpha = true}) =>
      toRgb.hex(shorten: shorten, withAlpha: withAlpha);

  static const double hMin = 0;
  static const double sMin = 0;
  static const double vMin = 0;
  static const double hMax = 360;
  static const double sMax = 100;
  static const double vMax = 100;
}
