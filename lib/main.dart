import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'db.dart';
import 'db_entry.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<DBEntry> _entries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.indeterminate_check_box),
            onPressed: () {
              newDatabase().then((_) {
                setState(() {});
              });
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: entries(),
        builder: (context, snapshot) {
          if (_entries == null && snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          _entries = snapshot.connectionState == ConnectionState.waiting ? _entries : snapshot.data;
          final List<ListTile> listEntries = _entries
              .map((DBEntry entry) => ListTile(
                    leading: Text('${entry.id}'),
                    title: Text(entry.name),
                    trailing: FlatButton(
                      child: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          deleteEntry(entry.id);
                        });
                      },
                    ),
                  ))
              .toList();
          return ListView(
            children: listEntries,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          generateWordPairs().take(1).forEach((word) {
            newEntry(word.toString()).then((id) {
              setState(() {
                print('New entry: $id');
              });
            });
          });
        },
      ),
    );
  }
}
