import 'package:flutter/material.dart';

class Palette {
  // Primary Colors
  static const Color primaryColor =
      Color.fromARGB(255, 17, 134, 40); // Deep Green (Primary)
  static const Color secondaryColor =
      Color.fromARGB(255, 15, 102, 143); // Light Blue (Secondary)

  // Text Colors
  static const Color textColor = Color(0xFF212121); // Main text (Dark)
  static const Color secondaryTextColor =
      Color.fromRGBO(91, 91, 91, 1); // Secondary text (Grayish)
  static const Color tertiaryTextColor =
      Color(0xFFB0BEC5); // Tertiary (Lighter Gray)

  // Field & Background Colors
  static const Color backgroundColor =
      Color(0xFFE0F2F1); // Light Teal for background
  static const Color fieldBackground =
      Color(0xFFF1F8E9); // Light Green for input fields

  // Border and Focused Field Colors
  static const Color borderColor = Color(0xFFBDBDBD); // Default border
  static const Color focusedFieldBorder =
      Color(0xFF00796B); // Focused border (Green)

  // Action/Status Colors
  static const Color accentColor = Color(0xFF0288D1); // Accent (Blue)
  static const Color errorColor = Color(0xFFE57373); // Error (Red)
  static const Color successColor = Color(0xFF4CAF50); // Success (Green)
  static const Color warningColor = Color(0xFFFFEB3B); // Warning (Yellow)

  // Hover and Highlight Colors
  static const Color hoverColor = Color(0xFF00ACC1); // Hover (Bluish-Green)
  static const Color highlightColor =
      Color(0xFF80CBC4); // Highlight (Soft Green)

  // Miscellaneous
  static const Color transparentColor = Colors.transparent; // Transparent Color
  static const Color smokeWhite = Color(0xFFFFFFFF); // Pure White
}
