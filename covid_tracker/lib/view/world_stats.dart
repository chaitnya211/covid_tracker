import 'package:covid_tracker/Model/WorldStatsModel.dart';
import 'package:covid_tracker/Services/stats_services.dart';
import 'package:covid_tracker/view/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStats extends StatefulWidget {
  const WorldStats({super.key});

  @override
  State<WorldStats> createState() => _WorldStatsState();
}

class _WorldStatsState extends State<WorldStats> with TickerProviderStateMixin {

  late final AnimationController aController =
      AnimationController(vsync: this, duration: Duration(seconds: 2))
        ..repeat();

  @override
  void dispose() {
    super.dispose();
    aController.dispose();
  }

  final colorList = <Color>[
    Color(0xff4285f4),
    Color(0xff1aa260),
    Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatsServices statsServices = StatsServices();
    return SafeArea(
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              FutureBuilder(
                  future: statsServices.fetchWorldStats(),
                  builder: (context, AsyncSnapshot<WorldStatsModel> snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                          flex: 1,
                          child: SpinKitFadingCircle(
                            color: Colors.white,
                            size: 40,
                            controller: aController,
                          ));
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            PieChart(
                              dataMap: {
                                "Total": snapshot.data!.cases!.toDouble(),
                                "Recovered":
                                    snapshot.data!.recovered!.toDouble(),
                                "Deaths": snapshot.data!.deaths!.toDouble(),
                              },
                              chartValuesOptions: const ChartValuesOptions(
                                  chartValueStyle: TextStyle(color: Colors.black),
                                  showChartValuesInPercentage: true),
                              animationDuration: Duration(milliseconds: 1400),
                              chartType: ChartType.ring,
                              colorList: colorList,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 3.2,
                              legendOptions: LegendOptions(
                                  legendTextStyle: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                      fontSize: 15),
                                  legendPosition: LegendPosition.left),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * .06),
                              child: Card(
                                color: Colors.grey.shade900,
                                child: Column(
                                  children: [
                                    ReusableRow(
                                        title: 'Total',
                                        value:
                                            snapshot.data!.cases!.toString()),
                                    ReusableRow(
                                        title: 'Recovered',
                                        value: snapshot.data!.recovered!
                                            .toString()),
                                    ReusableRow(
                                        title: 'Deaths',
                                        value:
                                            snapshot.data!.deaths!.toString()),
                                    ReusableRow(
                                        title: 'Active',
                                        value:
                                            snapshot.data!.active!.toString()),
                                    // ReusableRow(
                                    //     title: 'Critical',
                                    //     value: snapshot.data!.critical!.toString()),
                                    // ReusableRow(
                                    //     title: 'Critical',
                                    //     value:
                                    //         snapshot.data!.population!.toString()),
                                    // ReusableRow(
                                    //     title: 'Critical',
                                    //     value: snapshot.data!.activePerOneMillion!
                                    //         .toString()),
                                    ReusableRow(
                                        title: 'Affected Countries',
                                        value: snapshot.data!.affectedCountries!
                                            .toString()),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CountriesListScreen()));
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Color(0xff1aa260),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "Track Countries",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;

  const ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 3),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(value)],
          ),
          SizedBox(height: 5),
          Divider()
        ],
      ),
    );
  }
}
