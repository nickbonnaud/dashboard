import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'global_colors.dart';

class MainTheme {
  static const Color _primary = Colors.white;
  static final Color _primaryVariant = Colors.grey[300]!;
  static const Color _constrastPrimary = Colors.black;

  static final Color _secondary = Colors.grey[800]!;
  static const Color _secondaryVariant = Colors.black;
  static const Color _constrastSecondary = Colors.white;
  
  
  static ThemeData themeData({required BuildContext context}) {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Theme.of(context).colorScheme.onSurface
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: _primary
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return Theme.of(context).colorScheme.callToActionDisabled;
            }
            return Theme.of(context).colorScheme.callToAction;
          }),
          elevation: MaterialStateProperty.resolveWith<double>((states) => states.contains(MaterialState.pressed) || states.contains(MaterialState.disabled) ? 0 : 2)
        )
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return _primaryVariant;
            }
            return null;
          }),
          side: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return BorderSide(color: Theme.of(context).colorScheme.callToActionDisabled);
            }
            return BorderSide(color: Theme.of(context).colorScheme.callToAction);
          }),
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF016fb9)
      ),
      appBarTheme: AppBarTheme(
        toolbarTextStyle: getDefaultFont()
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: Theme.of(context).colorScheme.callToAction,
        inactiveTrackColor: Theme.of(context).colorScheme.callToActionDisabled,
        thumbColor: Theme.of(context).colorScheme.callToAction,
      ),
      colorScheme: ColorScheme(
        primary: _primary, 
        primaryContainer: _primaryVariant,
        onPrimary: _constrastPrimary,

        secondary: _secondary,
        secondaryContainer: _secondaryVariant, 
        onSecondary: _constrastSecondary, 

        surface: Colors.grey,
        onSurface: Colors.black,
        background: _primary,
        onBackground: _constrastPrimary, 

        error: Colors.red,  
        onError: Colors.white, 
        brightness: Brightness.light,
      ),
      textTheme: _getTextTheme(context: context),
      disabledColor: const Color(0xFFcce2f1),
    );
  }

  static TextTheme _getTextTheme({required BuildContext context}) {
    return GoogleFonts.robotoCondensedTextTheme(Theme.of(context).textTheme);
  }

  static TextStyle getDefaultFont() {
    return GoogleFonts.robotoCondensed();
  }
}