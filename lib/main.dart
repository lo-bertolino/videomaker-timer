import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Button.dart';
import 'FilePage.dart';
import 'FileStorage.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Videomaker Timer',
      home: MyApp(),
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.tealAccent,
        primaryColor: Colors.tealAccent,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.tealAccent.shade400,
          splashColor: Colors.tealAccent.shade100,
        ),
        dividerColor: Colors.transparent,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({
    Key key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool started = false;
  Future<SharedPreferences> sp;
  DateTime startTime;
  String lastAction = '?';

  @override
  void initState() {
    sp = SharedPreferences.getInstance();
    sp.then((sp) {
      startTime = DateTime.tryParse(sp.getString('timer'));
      if (startTime != null) setState(() => started = true);
    });

    super.initState();
  }

  String getCurrentTime() => startTime != null
      ? DateTime.now().difference(startTime).toString().split('.')[0]
      : '0:00:00';

  void startTimer() {
    TextStorage.storage.writeFile('----------------BEGIN----------------\n');
    startTime = DateTime.now();
    sp.then((sp) => sp.setString('timer', startTime.toIso8601String()));
    setState(() => started = true);
  }

  void stopTimer() {
    TextStorage.storage.writeFile('-----------------END-----------------\n');
    sp.then((sp) => sp.remove('timer'));
    startTime = null;
    setState(() => started = false);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height / 3.9;
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        child: Column(
          children: <Widget>[
            buildTopBar(),
            Divider(height: 8.0),
            Button(
              text: 'Video In',
              color: Colors.tealAccent.shade100,
              onPressed: () => onPressed(button: 'Video In'),
              enabled: started,
              height: height,
            ),
            Divider(height: 8.0),
            Button(
              text: 'Video Out',
              color: Colors.tealAccent.shade700,
              onPressed: () => onPressed(button: 'Video Out'),
              enabled: started,
              height: height,
            ),
            Divider(height: 8.0),
            Button(
              text: 'Separazione',
              color: Colors.tealAccent.shade400,
              onPressed: () => onPressed(button: 'Separazione'),
              enabled: started,
              height: height,
            ),
          ],
        ),
      ),
    );
  }

  Row buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Last Action: ' + lastAction),
        ),
        FlatButton(
          onPressed: () {
            if (!started)
              startTimer();
            else {
              stopTimer();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text('Vuoi salvare il file?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Sì'),
                          onPressed: () async {
                            await TextStorage.storage
                                .readFile()
                                .then((file) => Share.share(file));
                            TextStorage.storage.clearFile();
                            lastAction = '-';
                            Navigator.maybePop(context);
                          },
                        ),
                        FlatButton(
                          child: Text('No'),
                          onPressed: () => TextStorage.storage
                              .clearFile()
                              .whenComplete(() => Navigator.maybePop(context)),
                        ),
                      ],
                    ),
              );
            }
          },
          child: Text(started ? 'Stop' : 'Start'),
          color: started ? Colors.redAccent : Colors.greenAccent,
          textColor: Colors.black87,
        )
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Timer',
        style: TextStyle(color: Colors.black87),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.share,
            color: Colors.black87,
          ),
          onPressed: () => TextStorage.storage.readFile().then(
                (file) => Share.share(file),
              ),
        ),
        IconButton(
          icon: Icon(
            Icons.insert_drive_file,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FilePage(),
              ),
            );
          },
        )
      ],
    );
  }

  onPressed({String button}) {
    final text = getCurrentTime() + ': ' + button;
    TextStorage.storage.writeFile(text + '\n');
    setState(() => lastAction = text);
  }
}
