import 'package:lib_colors/src/hsl.dart';
import 'package:lib_colors/src/rgb.dart';
import 'package:lib_colors/src/hsv.dart';

export 'package:lib_colors/src/hsl.dart';
export 'package:lib_colors/src/rgb.dart';
export 'package:lib_colors/src/hsv.dart';

abstract class Color {
  static Color parse(String css) {
    if(css.startsWith('#')) {
      // TODO from hex
      throw UnimplementedError('Parsing hex colors not implemented yet!');
    } else if(css.startsWith('rgb')) {
      return Rgb.parse(css);
    } else if(css.startsWith('hsl')) {
      return Hsl.parse(css);
    }

    throw FormatException('Unknown CSS color format!');
  }

  /// Returns CSS representation of the color
  String get css;

  /// Returns HEX representation of the color
  String hex({bool shorten = true, bool withAlpha = true});

  Color clone();

  void assignRgb(Rgb rgb);

  void assignHsl(Hsl hsl);

  bool get isDark;

  bool get isLight;

  double get brightness;

  void brighten({num percent = 10});

  void lighten({num percent = 10});

  void darken({num percent = 10});

  void mix(Color withColor, {num percent = 50});

  void tint({num percent = 10});

  void shade({num percent = 10});

  void desaturate({num percent = 10});

  void saturate({num percent = 10});

  void greyscale();

  void spin(num degree);

  void complement();

  Rgb get toRgb;

  Hsl get toHsl;

  Hsv get toHsv;
}

Rgb get black => Rgb();

Rgb get white => Rgb(r: 255, g: 255, b: 255);

Rgb get lime => Rgb(g: 255);

Rgb get green => Rgb(g: 128);

Rgb get DarkGreen => Rgb(g: 100);