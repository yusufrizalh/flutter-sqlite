import 'package:flutter/material.dart';
import 'package:flutter_sqlite/adddatawidget.dart';
import 'dart:async';
import 'package:flutter_sqlite/models/trans.dart';
import 'package:flutter_sqlite/database/dbconn.dart';
import 'package:flutter_sqlite/translist.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transactions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Transactions Home Page'),
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
  DbConn dbconn = DbConn();
  List<Trans> transList;
  int totalCount = 0;

  @override
  Widget build(BuildContext context) {
    if (transList == null) {
      transList = List<Trans>();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        child: new Center(
            child: new FutureBuilder(
          future: loadList(),
          builder: (context, snapshot) {
            return transList.length > 0
                ? new TransList(trans: transList)
                : new Center(
                    child: new Text(
                        'Tidak ada data, Tekan + untuk membuat data!',
                        style: Theme.of(context).textTheme.headline6));
          },
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddScreen(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: new FutureBuilder(
          future: loadTotal(),
          builder: (context, snapshot) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Total: $totalCount',
                  style: Theme.of(context).textTheme.headline6),
            );
          },
        ),
        color: Colors.cyanAccent,
      ),
    );
  }

  Future loadList() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<List<Trans>> futureTrans = dbconn.trans();
      futureTrans.then((transList) {
        setState(() {
          this.transList = transList;
        });
      });
    });
  }

  Future loadTotal() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<int> futureTotal = dbconn.countTotal();
      futureTotal.then((ft) {
        setState(() {
          this.totalCount = ft;
        });
      });
    });
  }

  _navigateToAddScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDataWidget()),
    );
  }
}
