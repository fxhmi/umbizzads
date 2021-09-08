// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:umbizz/HomeScreen.dart';
import 'package:umbizz/Services/category_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() {
    return _TaskHomePageState();
  }
}

class _TaskHomePageState extends State<TaskHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  List<charts.Series<Ads, String>> _seriesPieData;
  List<Ads> myData;

  _generateData(myData) {
    _seriesPieData = List<charts.Series<Ads, String>>().cast<charts.Series<Ads, String>>();
    _seriesPieData.add(
      charts.Series(
        //x value
        domainFn: (Ads task, _) => task.adsDetails,

        //y value
        measureFn: (Ads task, _) => int.parse(task.adsVal),
        colorFn: (Ads task, _) =>
             charts.ColorUtil.fromDartColor(Color(int.parse(task.colorVal))),
        id: 'categories',
        data: myData,
        labelAccessorFn: (Ads row, _) => "${row.adsVal}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Analytics'),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                Colors.deepPurple,
                Colors.blue,

                // Colors.lightBlueAccent,
                // Colors.blueAccent,

                // Colors.blueGrey,
                // Colors.grey,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
            ),
          ),
        ),
        leading: BackButton(
            onPressed: () {
              Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
              Navigator.pushReplacement(context, newRoute);
            }
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Ads> task = snapshot.data.docs
              .map((snap) => Ads.fromMap(snap.data()))
              .toList();
          return _buildChart(context, task);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Ads> taskdata) {
    myData = taskdata;
    _generateData(myData);

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0,),
              Text(
                'Popular Upload by Categories',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0,),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 5),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                        charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 4,
                        cellPadding:
                        new EdgeInsets.only(left: 8.0,right: 4.0, bottom: 4.0,top:4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 15),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ])
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}