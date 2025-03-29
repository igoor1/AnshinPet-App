import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:anshinpet/res/components/drawer_custom.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData("Cachorros", 9),
      ChartData("Gatos", 2),
      ChartData("Aves", 1),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [Image.asset('images/logo_minimal.png')],
        actionsPadding: EdgeInsets.fromLTRB(0, 5, 15, 2),
        iconTheme: IconThemeData(color: Color.fromRGBO(124, 84, 217, 1)),
      ),
      drawer: DrawerCustom(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Animais"),
            Center(
              child: Container(
                  width: 500,
                  height: 250,
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      series: <CartesianSeries<ChartData, String>>[
                        ColumnSeries<ChartData, String>(
                          color: Color.fromRGBO(124, 84, 217, 1),
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ])),
            ),
            Row(
              children: [
                Expanded(child: CardBuilder("Animais", "12")),
                Expanded(
                  child: CardBuilder("Cuidadores", "2"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CardBuilder("Ração", "28.2 kg"),
                ),
                Expanded(child: CardBuilder("Doações", "R\$: 209")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget CardBuilder(title, value) {
    return Card(
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
                color: Color.fromRGBO(124, 84, 217, 1)),
            child: ListTile(
              title: Center(
                  child: Text(
                title,
                style: TextStyle(color: Colors.white),
              )),
            ),
          ),
          Container(
            height: 90.0,
            alignment: Alignment.center,
            child: Text(value,
                style: TextStyle(
                    color: Color.fromRGBO(124, 84, 217, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
                textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
