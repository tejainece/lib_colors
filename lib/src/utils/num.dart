/// Skips fraction part for whole number
String shortenDouble(double v) {
  if (v.isNegative) throw ArgumentError.value(v, 'v', 'Cannot be negative!');
  num ret = v.truncate();
  if (ret != v) ret = v;
  return ret.toString();
}
