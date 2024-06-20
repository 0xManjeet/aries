import 'data_models.dart';

class OptionsData {
  final List<OptionPositionModel> options;

  OptionsData({
    required this.options,
  });

// horizontal axis data
  (double, double) underlyingPriceRange() {
    // buffer to add to the min and max strike price
    double buf = 0.2;
    double min =
        options.map((e) => e.strikePrice).reduce((a, b) => a > b ? b : a) *
            (1 - buf);
    double max =
        options.map((e) => e.strikePrice).reduce((a, b) => a > b ? a : b) *
            (1 + buf);
    return (min, max);
  }

  List<double> calculateProfit(double underlyingPrice) {
    return options.map((e) => e.calculateProfit(underlyingPrice)).toList();
  }
}
