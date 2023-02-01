import 'package:flutter/material.dart';
import './section.dart';
import './barmill.dart';
import './jalali_date.dart';

import 'package:http/http.dart' as http;

import 'dart:convert'; // for convert json to List<dynamic> (Map)
import 'dart:core';
import 'dart:async'; // for Timer class

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
//import 'package:timezone/src/date_time.dart';

//import './notification_service.dart';


import 'package:flutter_spinkit/flutter_spinkit.dart';


import 'package:workmanager/workmanager.dart';

import 'package:localstorage/localstorage.dart';

//import 'package:logger/logger.dart';

//import 'package:shared_preferences/shared_preferences.dart';


final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();


final storage = LocalStorage('my_data.json');

void getDataForWorkManager () async {

  try {
    if (storage.getItem('trucksLength') == null) {
      debugPrint("storage doesn't set . . .");
      //return ;
    }
  } catch(e) {
    debugPrint("Error happen get data from storage . . .");
  }

  int trucksLength;
  int sectionCounter;
  int barmillCounter;
  int whichNotificationIndex;

  try {
    trucksLength = int.parse(storage.getItem('trucksLength'));
    sectionCounter = int.parse(storage.getItem('sectionCounter'));
    barmillCounter = int.parse(storage.getItem('barmillCounter'));
    whichNotificationIndex = int.parse(storage.getItem('whichNotificationIndex'));
  } catch (e) {
    trucksLength = 0;
    sectionCounter = 0;
    barmillCounter = 0;
    whichNotificationIndex = 0;
  }




  PersianDate today = PersianDate.now();
  String thisDay = '';
  Map<dynamic,dynamic> body ;

  try {
    thisDay = today.toString();

    // debugPrint('today : $thisDay');
  } catch(e) {
    debugPrint('Error on parsing date ...');
  }

  try {
  String url = "http://81.12.5.107:81/api/BilletInput/GetBilletInputs/?username=6272&password=sj6272&startDate=$thisDay&endDate=$thisDay";
  //String url = "http://81.12.5.107:81/api/BilletInput/GetBilletInputs/?username=6272&password=sj6272&startDate=1401/10/16&endDate=1401/10/16";
  var uri = Uri.parse(url);
  var response = await http.get(uri);

  body = jsonDecode(response.body);
  //debugPrint(body.toString());

  //debugPrint(body['Result'].length.toString());
  //debugPrint('----- type ------' + body.runtimeType.toString());
  //debugPrint('------ type ------' + body['Result'].runtimeType.toString()); // List<dynamic>

  var result = body['Result'];

  int section = 0;
  int barmill = 0;

  //List<dynamic> secTruc = sectionTrucks;
  //List<dynamic> barTruc = barmillTrucks;

  List<dynamic> temperoryTrucks = [];

  //debugPrint( '----- type ----- ' + result.runtimeType.toString());

  for(var i=0;i<result.length;i++) {
    if( i < trucksLength  ) {
      continue;
    } else {
      if(result[i]['BilletType'].toLowerCase() == '3sp'.toLowerCase()) {
        section++;
      } else {
        barmill++;
      }
    }
  }






  tzData.initializeTimeZones();
  const String timeZoneName = 'Asia/Tehran';
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  //final scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, 1000);
  //final tzTime = tz.TZDateTime.utc(scheduleTime.year, scheduleTime.month, scheduleTime.day, 10, scheduleTime.minute + 1, scheduleTime.second);

  var androidPlatformChannelDetails = AndroidNotificationDetails(
    "truckbackground",
    "truckbackground",
    icon : "@mipmap/ic_launcher" ,
    //sound: RawResourceAndroidNotificationSound('notif1.mp3'),
    playSound: true,
    importance: Importance.max,
    priority: Priority.max,
    color: const Color(0xff2196f3),
  );

  var platformChannelDetails = NotificationDetails(android: androidPlatformChannelDetails);




  debugPrint("Reach 1 . . .");
  if( whichNotificationIndex == 0 ) {
    debugPrint("Reach 2 . . .");
    if( result.length > trucksLength ) {
      debugPrint("Reach 3 . . .");
      await _localNotifications.show(
          0,
          "تعداد"
              +
              " " + barmillCounter.toString() + " "
              +
              "عدد تریلی به سمت بارمیل وارد شد"
              +
              " "
              +
              "مجموع ورودی :"
              +
              " "
              +
              barmillCounter.toString()
          ,
          "تعداد"
              +
              " " + sectionCounter.toString() + " "
              +
              "عدد تریلی به سمت سکشن وارد شد"
              +
              " "
              +
              "مجموع ورودی :"
              +
              " "
              +
              sectionCounter.toString()
          ,
          platformChannelDetails
      );
    }
  } else if( whichNotificationIndex == 1 ) {
    debugPrint("Reach 4 . . .");
    if( section > sectionCounter ) {
      debugPrint("Reach 5 . . .");
      await _localNotifications.show(
          0,
          "تعداد"
              +
              " " + barmillCounter.toString() + " "
              +
              "عدد تریلی به سمت بارمیل وارد شد"
              +
              " "
              +
              "مجموع ورودی :"
              +
              " "
              +
              barmillCounter.toString()
          ,
          "تعداد"
              +
              " " + sectionCounter.toString() + " "
              +
              "عدد تریلی به سمت سکشن وارد شد"
              +
              " "
              +
              "مجموع ورودی :"
              +
              " "
              +
              sectionCounter.toString()
          ,
          platformChannelDetails
      );
    }
  } else if( whichNotificationIndex == 2 ) {
    debugPrint("Reach 6 . . .");
    if( barmill > barmillCounter ) {
      debugPrint("Reach 7 . . .");
      await _localNotifications.show(
          0,
          "تعداد"
              +
              " " + barmillCounter.toString() + " "
              +
              "عدد تریلی به سمت بارمیل وارد شد"
              +
              " "
              +
              "مجموع ورودی :"
              +
              " "
              +
              barmillCounter.toString()
          ,
          "تعداد"
              +
              " " + sectionCounter.toString() + " "
              +
              "عدد تریلی به سمت سکشن وارد شد"
              +
              " "
              +
              "مجموع ورودی :"
              +
              " "
              +
              sectionCounter.toString()
          ,
          platformChannelDetails
      );
    }
  }



  } catch(e) {
    debugPrint('Error on set URI ...');
  }

}







/*
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    int? totalExecutions;
    final _sharedPreference = await SharedPreferences.getInstance(); //Initialize dependency

    try { //add code execution
      totalExecutions = _sharedPreference.getInt("totalExecutions");
      _sharedPreference.setInt("totalExecutions", totalExecutions == null ? 1 : totalExecutions+1);
    } catch(err) {
      Logger().e(err.toString()); // Logger flutter package, prints error on the debug console
      throw Exception(err);
    }

    return Future.value(true);
  });
}
*/


@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    getDataForWorkManager();
    debugPrint("Native called background task . . ."); //simpleTask will be emitted here.
    return Future.value(true);
  });
}




void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  /*
  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: ( int id , String title , String body , String payload ));
  */



  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid
  );

  //await _localNotifications.initialize(initializationSettings);

  await _localNotifications.initialize(initializationSettings).then((_) {
    debugPrint('setupPlugin: setup success');
  }).catchError((Object error) {
    debugPrint('Error: $error');
  });




  /*
  initializing work manager
   */

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  //Workmanager().registerOneOffTask("task-identifier", "simpleTask");

  Workmanager().registerPeriodicTask(
    "periodic-task-identifier",
    "simplePeriodicTask",
    // When no frequency is provided the default 15 minutes is set.
    // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
    // frequency: const Duration(seconds: 15),
    tag : "fetchTruck",
    existingWorkPolicy: ExistingWorkPolicy.replace ,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );


  runApp(const MyApp());
}


void scheduleAlarm({ sectionCounter , barmillCounter , allSectionTrucks , allBarmillTrucks }) async {

  //tzData.initializeTimeZones();
  //final scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, DateTime.now());

  //var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds : 2));

  tzData.initializeTimeZones();
  const String timeZoneName = 'Asia/Tehran';
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  //final scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, 1000);
  //final tzTime = tz.TZDateTime.utc(scheduleTime.year, scheduleTime.month, scheduleTime.day, 10, scheduleTime.minute + 1, scheduleTime.second);

  var androidPlatformChannelDetails = AndroidNotificationDetails(
      "truck",
      "truck" ,
      icon : "@mipmap/ic_launcher" ,
      //sound: RawResourceAndroidNotificationSound('notif1.mp3'),
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      color: const Color(0xff2196f3),
  );


  var platformChannelDetails = NotificationDetails(android: androidPlatformChannelDetails);


  await _localNotifications.show(
      0,
      "تعداد"
      +
      " " + barmillCounter.toString() + " "
      +
      "عدد تریلی به سمت بارمیل وارد شد"
      +
      " "
      +
      "مجموع ورودی :"
      +
      " "
      +
      allBarmillTrucks.toString()
      ,
      "تعداد"
      +
      " " + sectionCounter.toString() + " "
      +
      "عدد تریلی به سمت سکشن وارد شد"
      +
      " "
      +
      "مجموع ورودی :"
      +
      " "
      +
      allSectionTrucks.toString()
      ,
      platformChannelDetails
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تریلی',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(
          title: 'محموله ی ورودی',
      ),
      routes: {
        '/section' : (context) => const Section(trucks: []),
        '/barmill' : (context) => const Barmill(trucks: []),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //late final NotificationService notificationService;

  bool loading = true;

  String date = '';

  List<dynamic> trucks = [];
  List<dynamic> tempTrucks = [];

  List<dynamic> sectionTrucks = [];
  List<dynamic> barmillTrucks = [];

  int sectionCounter = 0;
  int barmillCounter = 0;

  int whichNotificationIndex = 0;

  List<String> whichNotification = [
    'هم بارمیل هم سکشن',
    'فقط بارمیل' ,
    'فقط سکشن' ,
    'خاموش'
  ];


  // sectionDifferece = sectionCounter - sectionTrucks.length
  // barmilDifference = barmillCounter - barmillTrucks.length


  void processResult(List<dynamic> result) async {

    int section = 0;
    int barmill = 0;

    List<dynamic> secTruc = sectionTrucks;
    List<dynamic> barTruc = barmillTrucks;

    List<dynamic> temperoryTrucks = [];

    //debugPrint( '----- type ----- ' + result.runtimeType.toString());

    for(var i=0;i<result.length;i++) {
      if( i < trucks.length  ) {
        continue;
      } else {
        if(result[i]['BilletType'].toLowerCase() == '3sp'.toLowerCase()) {
          section++;
          secTruc.insert(secTruc.length,result[i]);
        } else {
          barmill++;
          barTruc.insert(barTruc.length,result[i]);
        }
      }
    }


    //debugPrint('section counter : ' + secTruc.length.toString());
    //debugPrint('barmill counter : ' + barTruc.length.toString());


    //debugPrint('secTruc type : ' + secTruc.runtimeType.toString());
    //debugPrint('barTruc type : ' + barTruc.runtimeType.toString());


    /*
    if( whichNotificationIndex == 0 ) {
      if( result.length > trucks.length ) {
        showTestNotification( sectionCounter: section , barmillCounter: barmill , allSectionTrucks: sectionTrucks.length , allBarmillTrucks: barmillTrucks.length );
      }
    } else if( whichNotificationIndex == 1 ) {
      if( secTruc.length > sectionTrucks.length ) {
        showTestNotification( sectionCounter: section , barmillCounter: barmill , allSectionTrucks: sectionTrucks.length , allBarmillTrucks: barmillTrucks.length );
      }
    } else if( whichNotificationIndex == 2 ) {
      if( barTruc.length > barmillTrucks.length ) {
        showTestNotification( sectionCounter: section , barmillCounter: barmill , allSectionTrucks: sectionTrucks.length , allBarmillTrucks: barmillTrucks.length );
      }
    }

     */


    if( result.length > trucks.length ) {

      if(secTruc.length > sectionCounter) {
        _setSectionCounter(section);
        _setSectionTrucks(secTruc);
        await storage.setItem('sectionCounter', section);
      }

      if( barTruc.length > barmillCounter ) {
        _setBarmillCounter(barmill);
        _setBarmillTrucks(barTruc);
        await storage.setItem('barmillCounter', barmill);
      }

      _setTrucks(result);
      await storage.setItem('trucksLength', result.length);

    }

    if( loading == true ) {
      _setLoading(false);
    }




  }


  void showTestNotification({ sectionCounter , barmillCounter , allSectionTrucks , allBarmillTrucks }) {
    // Timer timer =
    Timer( const Duration(seconds: 1), () {
      scheduleAlarm( sectionCounter : sectionCounter , barmillCounter : barmillCounter , allSectionTrucks : allSectionTrucks , allBarmillTrucks : allBarmillTrucks );
      //debugPrint("Schedule Alarm Started ...");
    });
  }






  void setPeriodic() {

    // Periodic task registration


    Timer.periodic(const Duration(seconds: 15), (timer) {
      //debugPrint(timer.tick.toString());
      getData();
    });

  }

  void getData() async {
    PersianDate today = PersianDate.now();
    String thisDay = '';
    Map<dynamic,dynamic> body ;

    try {
      thisDay = today.toString();
      _setDate(thisDay);
      debugPrint('today : $thisDay');
    } catch(e) {
      debugPrint('Error on parsing date ...');
    }

    try {
      String url = "http://81.12.5.107:81/api/BilletInput/GetBilletInputs/?username=6272&password=sj6272&startDate=$thisDay&endDate=$thisDay";
      //String url = "http://81.12.5.107:81/api/BilletInput/GetBilletInputs/?username=6272&password=sj6272&startDate=1401/10/16&endDate=1401/10/16";
      var uri = Uri.parse(url);
      var response = await http.get(uri);

      body = jsonDecode(response.body);
      //debugPrint(body.toString());

      //debugPrint(body['Result'].length.toString());
      //debugPrint('----- type ------' + body.runtimeType.toString());
      //debugPrint('------ type ------' + body['Result'].runtimeType.toString()); // List<dynamic>
      processResult(body['Result']);



    } catch(e) {
      debugPrint('Error on set URI ...');
    }

  }



  void initData() async {
    if( await storage.getItem('whichNotificationIndex') != null ) {
      try {
        var i = await storage.getItem('whichNotificationIndex');
        whichNotificationIndex = int.parse(i);
      } catch(e) {
        debugPrint("Error from getting whichNotificationIndex");
      }
    } else {
      await storage.setItem('whichNotificationIndex', whichNotificationIndex);
    }
  }


  void changeNotificationIndex () {
    setState(() {
      if(whichNotificationIndex >= 3) {
        whichNotificationIndex = 0;
      } else {
        whichNotificationIndex = whichNotificationIndex + 1;
      }
      storage.setItem('whichNotificationIndex', whichNotificationIndex);
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    //notificationService = NotificationService();
    //notificationService.initializePlatformNotifications();
    super.initState();

    initData();
    //getData();
    //showTestNotification();
    setPeriodic();
  }

  void _setLoading(value) {
    setState(() {
      loading = value;
    });
  }


  void _setDate(String today) {
    setState(() {
      date = today;
    });
  }

  void _setSectionCounter(counter) {
    setState(() {
      sectionCounter = counter;
    });
  }

  void _setBarmillCounter(counter) {
    setState(() {
      barmillCounter = counter;
    });
  }


  void _setSectionTrucks(sectrucks) {
    setState(() {
      sectionTrucks = sectrucks;
    });
  }

  void _setBarmillTrucks(bartrucks) {
    setState(() {
      barmillTrucks = bartrucks;
    });
  }


  void _setTrucks(theTrucks) {
    setState(() {
      trucks = theTrucks;
    });
  }

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
            widget.title ,
            style : const TextStyle(
              fontFamily: 'Shabnam',
            )
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: Content(
          loading : loading ,
          date: date,
          sectionTrucks: sectionTrucks,
          barmillTrucks: barmillTrucks,
          whichNotificationIndex: whichNotificationIndex,
          whichNotification: whichNotification,
          changeNotificationIndex : changeNotificationIndex
      ),
    );
  }
}

class Content extends StatefulWidget {
  const Content({
    Key? key,
    required this.loading,
    required this.date,
    required this.sectionTrucks,
    required this.barmillTrucks,
    required this.whichNotificationIndex,
    required this.whichNotification ,
    required this.changeNotificationIndex ,
  }) : super(key: key);

  final String date;
  final List<dynamic> sectionTrucks;
  final List<dynamic> barmillTrucks;
  final bool loading;
  final int whichNotificationIndex ;
  final List<String> whichNotification;
  final Function changeNotificationIndex;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {





  @override
  void initState() {

    //initData();
    // TODO: implement initState
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    if(widget.loading == true) {
      /*
      return Center(
        child : Text('loading...')
      );
      */
      return const Center(
          child : SpinKitFoldingCube(
            color: Colors.black26,
            size: 100.0,
          ),
        );
    } else {
      return Center(

        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget> [
            ElevatedButton(onPressed: () {
              widget.changeNotificationIndex();
            }, child: Text(
              'دریافت نوتیفیکیشن'
               +
               ' '
               +
               widget.whichNotification[widget.whichNotificationIndex]
            )),
            HomeContent(date: widget.date, sectionTrucks: widget.sectionTrucks, barmillTrucks: widget.barmillTrucks),
          ],
        ),
      );
    }
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    Key? key,
    required this.date,
    required this.sectionTrucks,
    required this.barmillTrucks,
  }) : super(key: key);

  final String date;
  final List sectionTrucks;
  final List barmillTrucks;

  @override
  Widget build(BuildContext context) {
    return Column(
      // Column is also a layout widget. It takes a list of children and
      // arranges them vertically. By default, it sizes itself to fit its
      // children horizontally, and tries to be as tall as its parent.
      //
      // Invoke "debug painting" (press "p" in the console, choose the
      // "Toggle Debug Paint" action from the Flutter Inspector in Android
      // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
      // to see the wireframe for each widget.
      //
      // Column has various properties to control how it sizes itself and
      // how it positions its children. Here we use mainAxisAlignment to
      // center the children vertically; the main axis here is the vertical
      // axis because Columns are vertical (the cross axis would be
      // horizontal).
      mainAxisAlignment: MainAxisAlignment.center,

      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                date ,
                style : const TextStyle(
                  fontFamily: 'Shabnam',
                )
            ),
            const Text(
                ' : تاریخ امروز',
                style : TextStyle(
                  fontFamily: 'Shabnam',
                )
            ),
          ],
        ),
        GestureDetector(
          onTap : () => {
            //Navigator.pushNamed(context, '/section')
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Section(trucks: sectionTrucks,),
                )
            )
          },
          child: Container(
              color: Colors.grey[800],
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              child : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                      width: 100,
                      child : Image.asset('images/icon.png')
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                          'سکشن' ,
                          style : TextStyle(
                            fontFamily: 'Shabnam',
                            color: Colors.white,
                          )
                      ),
                      const SizedBox(height:30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                              'تریلی' ,
                              style : TextStyle(
                                fontFamily: 'Shabnam',
                                color: Colors.white,
                              )
                          ),
                          const SizedBox(width:10.0),
                          Text(
                              '${sectionTrucks.length}' ,
                              style : const TextStyle(
                                fontFamily: 'Shabnam',
                                fontSize: 30,
                                color: Colors.white,
                              )
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
          ),
        ),
        const SizedBox(height:20.0),
        GestureDetector(
          onTap : () => {
            //Navigator.pushNamed(context, '/barmill')
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Barmill(trucks: barmillTrucks,),
                )
            )
          },
          child: Container(
              color: Colors.grey[800],
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              child : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                      width: 100,
                      child : Image.asset('images/icon.png')
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                          'بارمیل' ,
                          style : TextStyle(
                            fontFamily: 'Shabnam',
                            color: Colors.white,
                          )
                      ),
                      const SizedBox(height:30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                              'تریلی' ,
                              style : TextStyle(
                                fontFamily: 'Shabnam',
                                color: Colors.white,
                              )
                          ),
                          const SizedBox(width:10.0),
                          Text(
                              '${barmillTrucks.length}' ,
                              style : const TextStyle(
                                fontFamily: 'Shabnam',
                                fontSize: 30,
                                color: Colors.white,
                              )
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
          ),
        ),
      ],
    );
  }
}
