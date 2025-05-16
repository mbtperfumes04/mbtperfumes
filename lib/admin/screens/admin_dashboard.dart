import 'package:flutter/material.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../providers/admin/admin_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

enum FilterType { day, week, month, overall }

class _AdminDashboardState extends State<AdminDashboard> {
  FilterType _selectedFilter = FilterType.overall;

  Map<String, double> getDailySales(List orders) {
    final Map<String, double> sales = {};
    for (var order in orders) {
      final dateKey = "${order.createdAt.year}-${order.createdAt.month}-${order.createdAt.day}";
      if (sales.containsKey(dateKey)) {
        sales[dateKey] = sales[dateKey]! + order.amount;
      } else {
        sales[dateKey] = order.amount;
      }
    }
    return sales;
  }

  Map<String, double> getWeeklySales(List orders) {
    final Map<String, double> sales = {};
    for (var order in orders) {
      final year = order.createdAt.year;
      final week = _weekNumber(order.createdAt);
      final key = "$year-W$week";
      if (sales.containsKey(key)) {
        sales[key] = sales[key]! + order.amount;
      } else {
        sales[key] = order.amount;
      }
    }
    return sales;
  }

  Map<String, double> getMonthlySales(List orders) {
    final Map<String, double> sales = {};
    for (var order in orders) {
      final key = "${order.createdAt.year}-${order.createdAt.month}";
      if (sales.containsKey(key)) {
        sales[key] = sales[key]! + order.amount;
      } else {
        sales[key] = order.amount;
      }
    }
    return sales;
  }

  Map<String, double> getDaySales(List orders) {
    final Map<String, double> sales = {};
    final now = DateTime.now();
    for (var order in orders) {
      final created = order.createdAt;
      if (now.year == created.year && now.month == created.month && now.day == created.day) {
        final hour = created.hour;
        final key = hour.toString().padLeft(2, '0') + ":00";
        if (sales.containsKey(key)) {
          sales[key] = sales[key]! + order.amount;
        } else {
          sales[key] = order.amount;
        }
      }
    }
    return sales;
  }

  int _weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysPassed = date.difference(firstDayOfYear).inDays;
    return ((daysPassed + firstDayOfYear.weekday) / 7).ceil();
  }

  Widget buildLineChart(Map<String, double> salesMap) {
    final sortedKeys = salesMap.keys.toList()..sort();
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedKeys.length; i++) {
      spots.add(FlSpot(i.toDouble(), salesMap[sortedKeys[i]]!));
    }

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < sortedKeys.length) {
                  final label = sortedKeys[index];
                  String displayLabel;
                  if (_selectedFilter == FilterType.day) {
                    displayLabel = label;
                  } else if (_selectedFilter == FilterType.week) {
                    displayLabel = label.replaceAll('W', 'Wk ');
                  } else if (_selectedFilter == FilterType.month) {
                    final parts = label.split('-');
                    displayLabel = "${parts[1]}/${parts[0].substring(2)}";
                  } else {
                    final parts = label.split('-');
                    displayLabel = parts.length > 2 ? parts[2] : label;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(displayLabel, style: TextStyle(fontSize: 10)),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        minX: 0,
        maxX: (sortedKeys.length - 1).toDouble(),
        minY: 0,
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
            spots: spots,
          )
        ],
      ),
    );
  }

  Map<String, double> getSalesByFilter(FilterType filter, List orders) {
    switch (filter) {
      case FilterType.day:
        return getDaySales(orders);
      case FilterType.week:
        return getWeeklySales(orders);
      case FilterType.month:
        return getMonthlySales(orders);
      case FilterType.overall:
      default:
        return getDailySales(orders);
    }
  }

  Widget buildFilterButton(String label, FilterType filter) {
    final bool isSelected = _selectedFilter == filter;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    final todaySales = adminProvider.orders.where((order) {
      DateTime today = DateTime.now();
      DateTime orderDate = order.createdAt;
      return today.year == orderDate.year &&
          today.month == orderDate.month &&
          today.day == orderDate.day;
    });

    final pendingOrders = adminProvider.orders.where((order) {
      return order.orderStatus.toLowerCase() == 'pending';
    });

    final completedOrders = adminProvider.orders.where((order) {
      return order.orderStatus.toLowerCase() == 'completed';
    });

    final salesMap = getSalesByFilter(_selectedFilter, adminProvider.orders);

    return Scaffold(
      body: CustomBody(
        isGradient: false,
        customBG: Color(0xfff6f6ef),
        appBar: SliverAppBar(
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Admin Panel'),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            margin: EdgeInsets.only(top: screenHeight * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    width: screenWidth * 0.43,
                    height: screenWidth * 0.43,
                    decoration: BoxDecoration(
                      color: Color(0xffad2d2f),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          child: Icon(Icons.monetization_on_outlined, color: Color(0xffad2d2f)),
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        Text('₱ ${todaySales.fold(0.0, (sum, order) => sum + order.amount)}',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: screenWidth * 0.045),
                        ),
                        Text("Today's Sales",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: screenWidth * 0.035),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    width: screenWidth * 0.43,
                    height: screenWidth * 0.43,
                    decoration: BoxDecoration(
                      color: Color(0xff988478),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          child: Icon(Icons.list_alt_sharp, color: Color(0xff988478)),
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        Text(pendingOrders.length.toString(),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: screenWidth * 0.045),
                        ),
                        Text("Pending Orders",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: screenWidth * 0.035),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            margin: EdgeInsets.only(top: screenHeight * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    width: screenWidth * 0.43,
                    height: screenWidth * 0.43,
                    decoration: BoxDecoration(
                      color: Color(0xffb4a69b),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          child: Icon(Icons.show_chart, color: Color(0xffb4a69b)),
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        Text('444',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: screenWidth * 0.045),
                        ),
                        Text("Perfume Stocks",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: screenWidth * 0.035),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    width: screenWidth * 0.43,
                    height: screenWidth * 0.43,
                    decoration: BoxDecoration(
                      color: Color(0xffa42419),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          child: Icon(Icons.check_circle_outline, color: Color(0xffa42419)),
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        Text(completedOrders.length.toString(),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: screenWidth * 0.045),
                        ),
                        Text("Completed Orders",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: screenWidth * 0.035),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            margin: EdgeInsets.only(top: screenHeight * 0.01),
            child: Row(
              children: [
                Text('Order Overview',
                  style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            margin: EdgeInsets.only(top: screenHeight * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildFilterButton("Day", FilterType.day),
                buildFilterButton("Week", FilterType.week),
                buildFilterButton("Month", FilterType.month),
                buildFilterButton("Overall", FilterType.overall),
              ],
            ),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 16),
            child: salesMap.isEmpty
                ? Center(child: Text("No data for selected filter"))
                : buildLineChart(salesMap),
          )
        ],
      ),
    );
  }
}
