import 'package:flutter/material.dart';

class ThemeUtil {
  static ThemeData mainTheme() {
    final ThemeData theme = ThemeData(
      // fontFamily: "NotoSerif",
      appBarTheme: AppBarTheme(
        color: const Color(0xFF1D63A7),
        iconTheme: const IconThemeData(
          size: 30,
          color: Colors.white,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelStyle: TextStyle(fontSize: 19),
        unselectedLabelStyle: TextStyle(fontSize: 16),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF1D63A7),
        foregroundColor: Colors.white,
      ),
      // scaffoldBackgroundColor: Colors.tealAccent[100],
      // canvasColor: Colors.tealAccent[100],
      colorScheme: ThemeData().colorScheme.copyWith(
            // brightness: Brightness.dark,
            primary: const Color(0xFF1E88E5),
            onPrimary: Colors.white,
            secondary: const Color(0xFF1D63A7),
            onSecondary: Colors.white,
            tertiary: Colors.black.withOpacity(0.6),
            onTertiary: Colors.grey.shade200,
          ),
    );

    return theme.copyWith(
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: theme.colorScheme.tertiary,
        ),
        bodyMedium: TextStyle(
          fontSize: 17,
          // fontFamily: "NotoSerif",
          fontWeight: FontWeight.w400,
          color: theme.colorScheme.tertiary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.tertiary,
        ),
        titleMedium: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w500,
          // fontFamily: "NotoSerif",
          color: theme.colorScheme.tertiary,
          // color: theme.colorScheme.onSecondary,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          // fontFamily: "NotoSerif",
          color: theme.colorScheme.onPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          // fontFamily: "NotoSerif",
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
