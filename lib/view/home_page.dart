import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/res/components/appbar_custom.dart';
import 'package:anshinpet/res/components/bottom_navigation_bar_custom.dart';
import 'package:anshinpet/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:anshinpet/res/components/drawer_custom.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel()..fetchHomeData(),
      child: Scaffold(
        appBar: AppbarCustom(),
        drawer: DrawerCustom(),
         body: Consumer<HomeViewModel>(
          builder: (context, homeViewModel, _) {

            if (homeViewModel.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            final List<ChartData> chartData = [
              ChartData("Cachorros", homeViewModel.quantityDogs.toDouble()),
              ChartData("Gatos", homeViewModel.quantityCats.toDouble()),
              ChartData("Aves", homeViewModel.quantityBirds.toDouble()),
            ];

            return SingleChildScrollView(
              child: Column(
                children: [
                  Text("Animais"),
                  Center(
                    child: Container(
                      width: 500,
                      height: 250,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 217, 217, 217),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.all(15),
                      child: SfCartesianChart(
                        backgroundColor: Colors.transparent,
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries<ChartData, String>>[
                          ColumnSeries<ChartData, String>(
                            color: AppColors.primary,
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CardBuilder("Animais", homeViewModel.quantityAnimals.toString()),
                      ),
                      Expanded(
                        child: CardBuilder("Cuidadores", homeViewModel.quantityUsers.toString()),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CardBuilder("Ração", "${homeViewModel.quantityDonations}kg"),
                      ),
                      Expanded(child: CardBuilder("Doações", "R\$: ${homeViewModel.quantityMoney}")),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBarCustom(valueIndex: 1),
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
                color: AppColors.primary),
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
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
                textAlign: TextAlign.center),
          ),
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
