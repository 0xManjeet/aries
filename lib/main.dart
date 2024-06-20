import 'package:flutter/material.dart';
import 'package:flutter_challenge/app/features/options_trading/options_calculator_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const AriesAssignment());
}

class AriesAssignment extends StatelessWidget {
  const AriesAssignment({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData darkTheme = ThemeData.dark(
      useMaterial3: true,
    )..copyWith(textTheme: GoogleFonts.rubikTextTheme());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Options Profit Calculator',
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const OptionsCalculatorPage(),
    );
  }
}
