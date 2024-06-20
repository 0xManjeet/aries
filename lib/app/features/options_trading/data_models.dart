import 'dart:math';

class OptionPositionModel {
  final bool isCall;
  final bool isLong;
  final double strikePrice;
  final double ask;
  final double bid;
  final int quantity;
  final DateTime expirationDate;

  double get premium => isLong ? ask : bid;
  bool get isLongPut => isLong && !isCall;
  bool get isShortPut => !isLong && !isCall;
  bool get isLongCall => isLong && isCall;
  bool get isShortCall => !isLong && isCall;

  OptionPositionModel({
    required this.isCall,
    required this.isLong,
    required this.strikePrice,
    required this.quantity,
    required this.expirationDate,
    required this.ask,
    required this.bid,
  });

  factory OptionPositionModel.fromMap(Map<String, dynamic> map) {
    return OptionPositionModel(
      isCall: map['type'] == 'Call',
      isLong: map['long_short'] == 'long',
      strikePrice: double.parse(map['strike_price'].toString()),
      quantity: int.tryParse(map['quantity'].toString()) ?? 1,
      ask: double.parse(map['ask'].toString()),
      bid: double.parse(map['bid'].toString()),
      expirationDate: DateTime.parse(map['expiration_date'].toString()),
    );
  }

  static List<OptionPositionModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((e) => OptionPositionModel.fromMap(e)).toList();
  }

  double calculateProfit(double underlyingPrice) {
    if (isLongPut) {
      return max(0, strikePrice - underlyingPrice) - premium;
    }
    if (isShortPut) {
      return premium - max(0, strikePrice - underlyingPrice);
    }
    if (isLongCall) {
      return max(0, underlyingPrice - strikePrice) - premium;
    }
    if (isShortCall) {
      return premium - max(0, underlyingPrice - strikePrice);
    }
    return 0;
  }

  double calculateBreakevenPrice() {
    if (isLongPut) {
      return strikePrice - premium;
    }
    if (isShortPut) {
      return strikePrice - premium;
    }
    if (isLongCall) {
      return strikePrice + premium;
    }
    if (isShortCall) {
      return strikePrice + premium;
    }
    return 0;
  }

  double maxProfit() {
    if (isLongPut) {
      return strikePrice - premium;
    }
    if (isLongCall) {
      return double.infinity;
    }
    if (isShortPut || isShortCall) {
      return premium;
    }
    return 0;
  }

  double maxLoss() {
    if (isLongPut || isLongCall) {
      return premium;
    }
    if (isShortPut || isShortCall) {
      return isShortPut ? strikePrice - premium : double.infinity;
    }
    return 0;
  }

  String get legendName {
    return '${isCall ? 'Call' : 'Put'} ${isLong ? 'Long' : 'Short'} (${strikePrice.toStringAsFixed(2)})';
  }
}
