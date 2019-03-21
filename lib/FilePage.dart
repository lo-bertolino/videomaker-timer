import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'FileStorage.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  Future<String> text;

  @override
  void initState() {
    text = TextStorage.storage.readFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Timer',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.maybePop(context),
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
              Icons.delete_forever,
              color: Colors.black87,
            ),
            onPressed: () => delete(),
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: text,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if (!snapshot.hasError && snapshot.hasData)
                      return Text(
                        snapshot.data,
                        style: TextStyle(fontFamily: 'monospace', fontSize: 16),
                      );
                    else
                      return Text(
                        snapshot.error,
                        style: TextStyle(fontFamily: 'monospace'),
                      );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  delete() async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sicuro di voler eliminare il file?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Elimina'),
              onPressed: () => Navigator.maybePop(context, true),
            ),
            FlatButton(
              child: Text('Annulla'),
              onPressed: () => Navigator.maybePop(context, false),
            ),
          ],
        );
      },
    );
    if ((delete ?? false) == true) {
      await TextStorage.storage.clearFile();
      setState(() {
        text = TextStorage.storage.readFile();
      });
    }
  }
}
