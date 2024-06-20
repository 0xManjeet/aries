import 'package:fl_chart/fl_chart.dart' hide defaultGridLine;
import 'package:flutter/material.dart';
import 'package:flutter_challenge/app/extensions/buildcontext_extensions.dart';
import 'package:flutter_challenge/app/features/options_trading/options_models.dart';

import 'widgets/line_chart_widgets.dart';

class OptionsCalculatorChart extends StatefulWidget {
  final OptionsData optionsData;
  const OptionsCalculatorChart({super.key, required this.optionsData});

  @override
  State<OptionsCalculatorChart> createState() => _OptionsCalculatorChartState();
}

class _OptionsCalculatorChartState extends State<OptionsCalculatorChart> {
  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          axisNameSize: 22,
          axisNameWidget: const Text('at price (\$)'),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            maxIncluded: false,
            minIncluded: false,

            // interval: (maxX - minX) / 5,
            getTitlesWidget: (value, meta) {
              // if ((value - minX) % meta.appliedInterval > 5) {
              //   return const SizedBox.shrink();
              // }
              String label = value.toStringAsFixed(1);
              if (double.parse(value.toStringAsFixed(1)) == value.floor()) {
                label = value.floor().toString();
              }

              return SideTitleWidget(
                axisSide: meta.axisSide,
                // fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                child: Text(
                  label,
                  style:
                      const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              );
              // return Text(

              // );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            maxIncluded: false,
            minIncluded: false,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(1),
                style:
                    const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              );
            },
            interval: (maxY - minY) / 5,
            reservedSize: 40,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          axisNameSize: 24,
          axisNameWidget: Text(
            'Profit / Loss (\$)',
            style: TextStyle(fontSize: 12),
          ),
        ),
      );

  late double minX, maxX, minY = 0, maxY = 0;
  late List<double> range;
  @override
  void initState() {
    super.initState();
    calculateDataPoints();
  }

  void calculateDataPoints() {
    var x = widget.optionsData.underlyingPriceRange();
    minX = x.$1;
    maxX = x.$2;
    int rangeSize = 500;
    range = List.generate(
        rangeSize, (index) => minX + index * (maxX - minX) / rangeSize);
    for (var option in widget.optionsData.options.indexed) {
      for (var spot in range) {
        double profit = option.$2.calculateProfit(spot);
        if (profit > maxY) maxY = profit;
        if (profit < minY) minY = profit;
      }
    }
    minY -= minY.abs() * 0.2;
    maxY += maxY.abs() * 0.2;
  }

  int selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    for (var option in widget.optionsData.options.indexed) {
      for (var spot in range) {
        double profit = option.$2.calculateProfit(spot);
        if (profit > maxY) maxY = profit;
        if (profit < minY) minY = profit;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.theme.colorScheme.surfaceContainer,
      ),
      child: Column(
        children: [
          Container(
            height: 300,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: LineChart(
              LineChartData(
                extraLinesData: ExtraLinesData(
                  verticalLines: [
                    for (var option in widget.optionsData.options.indexed)
                      VerticalLine(
                        x: option.$2.calculateBreakevenPrice(),
                        dashArray: [2, 4],
                        strokeWidth: 1,
                        color: legendColors(context)[option.$1],
                      ),
                  ],
                ),
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    // Set this to true if the graph widget does not have enough space above it,
                    // I've set it to false because the animation looks better.
                    fitInsideVertically: false,
                    getTooltipColor: (touchedSpot) =>
                        context.theme.colorScheme.surfaceContainerLowest,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.gradient?.colors.first ??
                              touchedSpot.bar.color ??
                              context.theme.colorScheme.onSecondaryContainer,
                          fontSize: 10,
                        );
                        String text;
                        if (touchedSpot.y.isNegative) {
                          text =
                              '\$${touchedSpot.y.abs().toStringAsFixed(1)} loss';
                        } else {
                          text = '\$${touchedSpot.y.toStringAsFixed(1)} profit';
                        }
                        return LineTooltipItem(text, textStyle);
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) {
                    if (value == 0) {
                      return defaultGridLine(context, value, true);
                    }
                    return defaultGridLine(context, value, false);
                  },
                  getDrawingVerticalLine: (value) =>
                      defaultGridLine(context, value, false),
                ),
                titlesData: titlesData,
                borderData: FlBorderData(show: false),
                lineBarsData: getLineChartBarData(
                  context: context,
                  riskRewardData: widget.optionsData,
                  range: range,
                ),
                minX: minX,
                maxX: maxX,
                maxY: maxY,
                minY: minY,
              ),
            ),
          ),
          Column(
            children: [
              // two rows, each with max 2 elements
              for (int i = 0; i < widget.optionsData.options.length; i += 2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildLegend(
                      context: context,
                      color: legendColors(context)[i],
                      text: widget.optionsData.options[i].legendName,
                      isSelected: selectedOption == i,
                      onTap: () => setState(
                        () => selectedOption = i,
                      ),
                    ),
                    if (i + 1 < widget.optionsData.options.length)
                      buildLegend(
                        context: context,
                        color: legendColors(context)[i + 1],
                        text: widget.optionsData.options[i + 1].legendName,
                        isSelected: selectedOption == i + 1,
                        onTap: () => setState(
                          () => selectedOption = i + 1,
                        ),
                      ),
                  ],
                ),
            ],
          ),
          selectedOptionDetailsWidget(
            context,
            widget.optionsData.options[selectedOption],
          ),
        ],
      ),
    );
  }
}
