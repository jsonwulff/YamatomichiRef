import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart' as dateTimeline;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as dtp;
import 'package:intl/intl.dart';

FirebaseAnalytics analytics;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  analytics = FirebaseAnalytics();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var cards = List<MyCardWidget>();
  int counter = 1;
  var eventNameController = TextEditingController();
  var eventDescriptionController = TextEditingController();
  DateTime fromDate;
  DateTime toDate;

  void createCard() {
    setState(() {
      var card = new MyCardWidget(
        title: eventNameController.text,
        description: eventDescriptionController.text,
        fromDate: fromDate,
        toDate: toDate,
      );
      cards.add(card);
    });
    eventNameController.clear();
    eventDescriptionController.clear();
    fromDate = null;
    toDate = null;
    Navigator.of(context).pop();
  }

  void fromDatePicker() {
    showDateTimePicker(fromDate);
  }

  void toDatePicker() {
    showDateTimePicker(null);
  }

  void showDateTimePicker(DateTime from) {
    dtp.DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2022, 12, 31, 23, 59),
        theme: dtp.DatePickerTheme(
            headerColor: Colors.blue,
            backgroundColor: Colors.white,
            itemStyle: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16),
            cancelStyle: TextStyle(color: Colors.white, fontSize: 16)),
        onConfirm: (date) {
      print('confirm $date');
      (from == fromDate) ? fromDate = date : toDate = date;
    }, currentTime: DateTime.now(), locale: dtp.LocaleType.en);
  }

  void showPopUp() {
    setState(() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Create new event'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                      child: TextField(
                        controller: eventNameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          hintText: 'Enter event name',
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: TextField(
                        controller: eventDescriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          hintText: 'Enter event description',
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                          onPressed: fromDatePicker,
                          child: Text('Pick from date ')),
                      FlatButton(
                          onPressed: toDatePicker, child: Text('Pick to date'))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: FloatingActionButton(
                          onPressed: createCard,
                          child: Icon(Icons.add),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: FloatingActionButton(
                          onPressed: null,
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: Column(
        children: [
          dateTimeline.DatePicker(DateTime.now(),
              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.black,
              selectedTextColor: Colors.white, onDateChange: (date) {
            // New date selected
            /*setState(() {
              fromDate = date;
            });*/
          }),
          SingleChildScrollView(child: Column(
            children: List.unmodifiable(() sync* {
              yield* cards.toList();
            }()),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showPopUp,
        child: Icon(Icons.add),
      ),
    );
  }
}

class MyCardWidget extends StatelessWidget {
  MyCardWidget(
      {Key key, this.title, this.description, this.fromDate, this.toDate})
      : super(key: key);
  final String title;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;

  String formatDateTime(DateTime date) {
    if (date == null) return "";
    return DateFormat('dd-MM-yyyy - kk:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        width: 100,
        height: 130,
        child: Card(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('kk:mm').format(fromDate),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              Text(
                DateFormat('dd-MM').format(toDate),
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                DateFormat('kk:mm').format(toDate),
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
      Container(
        width: 250,
        height: 130,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Helvetica Neue',
                  fontSize: 20.0,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              /*Text(
                formatDateTime(fromDate),
                style: TextStyle(color: Colors.white),
              ),
              Text(
                formatDateTime(toDate),
                style: TextStyle(color: Colors.white),
              )*/
            ],
          ),
        ),
      ),
    ]);
  }
}
