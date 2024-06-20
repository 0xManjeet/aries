import 'package:flutter/material.dart';
import 'package:flutter_challenge/app/features/options_trading/options_models.dart';

import 'data_models.dart';
import 'options_calculator_chart.dart';
import 'sample_data.dart';

class OptionsCalculatorPage extends StatelessWidget {
  const OptionsCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Reward Calculator'),
      ),
      body: GraphWidget(positions: sampleData),
    );
  }
}

class GraphWidget extends StatelessWidget {
  final List<OptionPositionModel> positions;

  /// Supports upto 4 [OptionPositionModel]
  const GraphWidget({super.key, required this.positions})
      : assert(positions.length > 0 && positions.length <= 4);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        OptionsCalculatorChart(
          optionsData: OptionsData(options: positions),
        ),
      ],
    );
  }
}
