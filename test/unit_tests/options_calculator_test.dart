import 'package:flutter_challenge/app/features/options_trading/data_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('OptionPositionModel', () {
    var m = OptionPositionModel.fromMap({
      'strike_price': 100,
      'type': 'Call',
      'bid': 10.05,
      'ask': 12.04,
      'long_short': 'long',
      'expiration_date': '2025-12-17T00:00:00Z',
    });
    expect(m.strikePrice, 100);
    expect(m.premium, 12.04);
    expect(m.maxLoss().toStringAsFixed(2), '12.04');
    expect(m.maxProfit(), double.infinity);
  });
}
