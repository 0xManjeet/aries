import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/app/extensions/buildcontext_extensions.dart';

import '../../../utils/utils.dart';
import '../data_models.dart';
import '../options_models.dart';

FlLine defaultGridLine(BuildContext context, double value, bool highlighted) {
  return FlLine(
    color: highlighted
        ? context.theme.colorScheme.onSurface
        : context.theme.colorScheme.onSurface.withAlpha(50),
    strokeWidth: 0.4,
    dashArray: highlighted ? [12, 4] : [2, 4],
  );
}

Widget selectedOptionDetailsWidget(
  BuildContext context,
  OptionPositionModel option,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text('Max Profit'),
            Text('\$ ${doubleToString(option.maxProfit())}'),
          ],
        ),
        if (option.maxLoss() != double.infinity)
          Column(
            children: [
              const Text('Max Loss'),
              Text('\$ ${doubleToString(option.maxLoss().abs())}'),
            ],
          ),
        Column(
          children: [
            const Text('BEP'),
            Text(doubleToString(option.calculateBreakevenPrice())),
          ],
        ),
      ],
    ),
  );
}

Widget buildLegend({
  required BuildContext context,
  required Color color,
  required String text,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  Color backgroundColor = isSelected
      ? context.theme.colorScheme.primaryContainer
      : context.theme.colorScheme.surfaceContainerHigh;

  Color foregroundColor = isSelected
      ? context.theme.colorScheme.onPrimaryContainer
      : context.theme.colorScheme.onSurface;
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.translucent,
    child: Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            width: 24,
            height: 8,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: foregroundColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}

LineChartBarData getLineBarData({
  required OptionPositionModel option,
  required List<FlSpot> spots,
  required Color color,
}) {
  return LineChartBarData(
    isCurved: true,
    color: color,
    barWidth: 3,
    curveSmoothness: 0.12,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: spots,
  );
}

List<Color> legendColors(BuildContext context) => context.isDark
    ? [
        Colors.green.shade400,
        Colors.purple.shade400,
        Colors.yellow.shade400,
        Colors.pink.shade400,
      ]
    : [
        Colors.green,
        Colors.cyan,
        Colors.yellow,
        Colors.pink,
      ];

List<LineChartBarData> getLineChartBarData({
  required BuildContext context,
  required OptionsData riskRewardData,
  required List<double> range,
}) {
  return [
    for (var option in riskRewardData.options.indexed)
      getLineBarData(
        option: option.$2,
        spots:
            range.map((e) => FlSpot(e, option.$2.calculateProfit(e))).toList(),
        color: legendColors(context)[option.$1],
      )
  ];
}
