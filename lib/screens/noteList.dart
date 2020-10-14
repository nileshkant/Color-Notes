import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes/models/note.dart';
import 'package:notes/utils/sqlite_helper.dart';
import 'package:notes/screens/newNote.dart';
import 'package:notes/utils/theme_notifier.dart';
import 'package:notes/common/theme.dart';
import 'package:notes/common/themeChange.dart';

class MyNotes extends StatefulWidget {
  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  final sqlLiteHelper = SqlLiteHelper();
  Future<List<Note>> _listFuture;
  int gridAlign = 2;
  var _darkTheme = false;
  // init - set initial values
  @override
  void initState() {
    super.initState();
    // initial load
    _listFuture = updateAndGetList();
  }

  void _alignGrid() {
    setState(() {
      gridAlign = gridAlign == 1 ? 2 : 1;
    });
  }

  Future<List<Note>> updateAndGetList() async {
    await sqlLiteHelper.open();
    final List<Note> maps = await sqlLiteHelper.queryAll();
    return maps;
  }

  Future _pushToNoteRoute(Note noteObj) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewNote(noteObj),
        ));
    if (result == "saved") {
      setState(() {
        _listFuture = updateAndGetList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
                gridAlign == 2 ? Icons.view_agenda_outlined : Icons.border_all),
            onPressed: () {
              _alignGrid();
            },
          ),
          IconButton(
            icon: Icon(_darkTheme
                ? Icons.wb_sunny_outlined
                : Icons.nights_stay_outlined),
            onPressed: () {
              onThemeChanged(!_darkTheme, themeNotifier);
            },
          ),
        ],
        title: Text(
          'Notes',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: FutureBuilder<List<Note>>(
          future: _listFuture, // a previously-obtained Future<String> or null
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridAlign,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height /
                          (gridAlign == 2 ? 2 : 4)),
                ),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  print(snapshot.data);
                  return Card(
                    elevation: 5,
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Color(
                        int.parse(
                          'FF${snapshot.data[index].background}',
                          radix: 16,
                        ),
                      ).withOpacity(0.2)),
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          _pushToNoteRoute(snapshot.data[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${snapshot.data[index].title}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '${snapshot.data[index].noteBody}',
                                    maxLines: 8,
                                  ),
                                ), // Widget to display the list of project
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ],
              );
            } else {
              return Column(
                children: <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ],
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _pushToNoteRoute(null);
        },
        tooltip: 'Save Note',
        label: Text('New Note'),
      ),
    );
  }
}
