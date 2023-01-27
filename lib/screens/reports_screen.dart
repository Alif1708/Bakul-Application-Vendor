import 'package:flutter/material.dart';
import 'package:bakul_app_vendor/chart/bar_chart_sample1.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);
  static const String id = 'report-screen';

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4B41A),
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 50, bottom: 50, right: 10, left: 10),
          child: BarChartSample1(),
        ),
      ),
    );
  }
}
