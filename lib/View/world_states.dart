import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:covid_tracker_app/ViewModel/world_sates_view_model.dart';
import 'package:covid_tracker_app/View/countries_list_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class WorldStates extends StatefulWidget {
  const WorldStates({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WorldStatesState createState() => _WorldStatesState();
}

class _WorldStatesState extends State<WorldStates>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  WorldStatesViewModel newListViewModel = WorldStatesViewModel();

  final colorList = <Color>[
    Color.fromARGB(255, 12, 23, 135),
    Color.fromARGB(255, 6, 121, 25),
    Color.fromARGB(255, 241, 63, 47),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              Expanded(
                child: FutureBuilder(
                    future: newListViewModel.fetchWorldRecords(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SpinKitFadingCircle(
                              color: Color.fromARGB(255, 35, 12, 127),
                              size: 50.0,
                              controller: _controller,
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            PieChart(
                              dataMap: {
                                "Total": double.parse(
                                    //try calling response here  from api),
                                "Recovered": double.parse(
                                  //try calling response here  from api  ),
                                "Deaths": double.parse(
                                   //try calling response here  from api),
                              },
                              animationDuration: Duration(milliseconds: 1200),
                              chartLegendSpacing: 32,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 3.2,
                              colorList: colorList,
                              initialAngleInDegree: 0,
                              chartType: ChartType.ring,
                              ringStrokeWidth: 25,
                              legendOptions: const LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.left,
                                showLegends: true,
                                legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 17, 10, 112)),
                              ),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: true,
                                showChartValuesOutside: true,
                                decimalPlaces: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * .06),
                              child: Card(
                                elevation: 5,
                                color: Color.fromARGB(255, 255, 255, 255),
                                shadowColor: Colors.deepPurpleAccent,
                                child: Column(
                                  children: [
                                    20.heightBox,
                                    ReusableRow(
                                        title: 'Total Cases',
                                        value: snapshot.data!.cases.toString()),
                                    ReusableRow(
                                        title: 'Deaths',
                                        value:
                                            snapshot.data!.deaths.toString()),
                                    ReusableRow(
                                        title: 'Recovered',
                                        value: snapshot.data!.recovered
                                            .toString()),
                                    ReusableRow(
                                        title: 'Active',
                                        value:
                                            snapshot.data!.active.toString()),
                                    ReusableRow(
                                        title: 'Critical',
                                        value:
                                            snapshot.data!.critical.toString()),
                                    ReusableRow(
                                        title: 'Today Deaths',
                                        value: snapshot.data!.todayDeaths
                                            .toString()),
                                    ReusableRow(
                                        title: 'Today Recovered',
                                        value: snapshot.data!.todayRecovered
                                            .toString()),
                                    10.heightBox
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
                                            const CountriesListScreen()));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 13, 23, 111),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Text('Track Countries'),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title.text.white.semiBold.size(15).makeCentered(),
                  value.text.white.size(17).makeCentered(),
                ],
              ),
            ),
          ],
        )
            .box
            .rounded
            .shadow
            .size(MediaQuery.sizeOf(context).width * 1, 50)
            .color(Color.fromARGB(255, 63, 79, 199))
            .shadow
            .make());
  }
}
