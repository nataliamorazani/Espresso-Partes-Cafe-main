import 'package:flutter/material.dart';

class ThemeUtil {
  static ThemeData mainTheme() {
    final ThemeData theme = ThemeData(
      // fontFamily: "NotoSerif",
      appBarTheme: AppBarTheme(
        color: Colors.teal[700],
        iconTheme: const IconThemeData(
          size: 30,
          color: Colors.white,
        ),
      ),
      tabBarTheme: const TabBarTheme(
        labelStyle: TextStyle(fontSize: 16),
        unselectedLabelStyle: TextStyle(fontSize: 16),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.teal[700],
      ),
      // scaffoldBackgroundColor: Colors.tealAccent[100],
      // canvasColor: Colors.tealAccent[100],
      colorScheme: ThemeData().colorScheme.copyWith(
            // brightness: Brightness.dark,
            primary: Colors.teal[400],
            onPrimary: Colors.white,
            secondary: Colors.teal[600],
            onSecondary: Colors.white,
            tertiary: Colors.black.withOpacity(0.6),
            onTertiary: Colors.grey.shade200,
          ),
    );

    return theme.copyWith(
      textTheme: TextTheme(
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
