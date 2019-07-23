/*
class ColorParser {

  static final RegExp _beginsHash = new RegExp("^#");
  static final RegExp _hexColorRegExp = new RegExp("^#?([\\da-fA-F]{6})\$");
  static final RegExp _hexColorAbbreviatedRegExp = new RegExp("^#?([\\da-fA-F]{3})\$");

  static Color parse(String toParse, { Color orElse() }) {
    toParse = toParse.trim();
    return _parseRgb(toParse) ?? _parseHex(toParse) ??  _parseHsl(toParse) ?? _parseNamed(toParse) ?? orElse?.call() ?? null;
  }

  static Color _parseHex(String toParse) {
    if (_hexColorRegExp.hasMatch(toParse)) {
      return new HexColor(toParse);
    }

    if (_hexColorAbbreviatedRegExp.hasMatch(toParse)) {
      String _unAbbreviated = new String.fromCharCodes(toParse.replaceFirst(_beginsHash, "").codeUnits.map((c) => [c, c]).expand((c) => c));
      return new HexColor(_unAbbreviated);
    }

    return null;
  }

  static Color _parseNamed(String toParse) {
    try {
      return new RgbColor.name(toParse.toLowerCase());
    } catch (argumentError) {
      return null;
    }
  }

}
 */