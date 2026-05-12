import 'package:espresso_partes_cafe/models/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  final List<ChartData> data;
  // ignore: prefer_const_constructors_in_immutables
  const Chart(this.data, {Key? key}) : super(key: key);

  @override
  ChartState createState() => ChartState();
}

class ChartState extends State<Chart> {
  late TooltipBehavior _tooltip;
  late List<ChartData> data;
  double higherValue = 100;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = widget.data;
    _tooltip = TooltipBehavior(enable: true);
  }

  getHeightValue() {
    double higher = 100;
    for (final ChartData chartData in data) {
      if (higher < chartData.total) {
        higher = chartData.total;
      }
    }

    setState(() {
      higherValue = higher;
    });
  }

  @override
  Widget build(BuildContext context) {
    getHeightValue();
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(
          borderWidth: 20,
          text: "Suas vendas nos ultimos 12 meses",
          textStyle: Theme.of(context).textTheme.titleSmall,
        ),
        enableAxisAnimation: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        primaryXAxis: CategoryAxis(
          isInversed: true,
          arrangeByIndex: true,
          majorGridLines: const MajorGridLines(
            width: 0,
          ),
          interval: 1,
          minimum: 0,
          maximum: 11,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          rangePadding: ChartRangePadding.round,
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(dashArray: [7]),
          numberFormat: NumberFormat.compact(locale: "pt_Br"),
          minimum: 0,
          maximum: higherValue,
          interval: (higherValue / 6).floorToDouble(),
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        tooltipBehavior: _tooltip,
        series: <CartesianSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
            spacing: 0.1,
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.month,
            yValueMapper: (ChartData data, _) => data.total.floor(),
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ]);
  }
}
