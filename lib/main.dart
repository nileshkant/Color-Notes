import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/theme.dart';
import 'screens/noteList.dart';
import 'screens/newNote.dart';
import 'package:flutter/services.dart';
import 'package:notes/utils/theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
        ),
      ],
      child: MyApp(),
    ));
  });
  // });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    // Using MultiProvider is convenient when providing multiple objects.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Provider Demo',
      theme: themeNotifier.getTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => MyNotes(),
        '/newnote': (context) => NewNote(null),
      },
    );
  }
}
