/// Converts double to string with upto 2 decimal places, removing any trailing zeroes or decimal points if it's a whole number.
/// Returns 'unlimited' in case of -inf or +inf
String doubleToString(double d) {
  if (d.abs() == double.infinity) {
    return 'unlimited';
  }
  if (double.parse(d.toStringAsFixed(2)) == d.toInt()) {
    return d.toInt().toString();
  }
  return d.toStringAsFixed(2);
}
