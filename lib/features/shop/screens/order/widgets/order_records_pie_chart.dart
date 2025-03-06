import 'package:easyapp/utils/helpers/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:easyapp/features/shop/controllers/products/order_controller.dart';
import 'package:get/get.dart';
import 'package:easyapp/common/widgets/appbar/appbar.dart';
import 'package:intl/intl.dart';

class MOrderRecordsPieChart extends StatelessWidget {
  const MOrderRecordsPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = OrderController.instance;

    // Fetch data once when the widget is created
    orderController.fetchOrderRecords();

    return Scaffold(
      appBar: MAppBar(
        title: Text('Order Records', style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: Obx(() {
        final orders = orderController.orderRecords;

        if (orders.isEmpty) {
          return const Center(child: Text('No Data Found!'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Bar Chart
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: _generateBarGroups(orders),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < orders.length) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    THelperFunctions.getOrderFormattedDate(orders[index]['date'].toString()),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: true),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(thickness: 5, color: Colors.grey),

                // Table below the chart
                _buildDataTable(orders),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Generate bar chart data
  List<BarChartGroupData> _generateBarGroups(List<Map<String, dynamic>> orders) {
    return List.generate(orders.length, (index) {
      final order = orders[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (order['total'] as num).toDouble(),
            color: Colors.blue,
            width: 30,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      );
    });
  }


  /// Builds a table below the chart
  Widget _buildDataTable(List<Map<String, dynamic>> orders) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Orders', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: orders.map((order) {
        return DataRow(cells: [
          DataCell(Text(THelperFunctions.getFullOrderFormattedDate(order['date'].toString()))),
          DataCell(Text(order['noofOrders'].toString())),
          DataCell(Text(NumberFormat('#,##0').format(double.parse(order['total'].toStringAsFixed(2))))),
        ]);
      }).toList(),
    );
  }
}
