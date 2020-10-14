import 'package:notes/utils/theme_notifier.dart';
import 'package:notes/common/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
  (value)
      ? themeNotifier.setTheme(darkTheme)
      : themeNotifier.setTheme(lightTheme);
  var prefs = await SharedPreferences.getInstance();
  prefs.setBool('darkMode', value);
}
