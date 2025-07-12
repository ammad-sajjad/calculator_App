import 'package:calculator/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:popover/popover.dart';

void main() {
  runApp(CalculatorApp());
}
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
  ),
);

ThemeData darkMode = ThemeData(
brightness: Brightness.dark,
scaffoldBackgroundColor: Color(0xFF000000), // your black background
appBarTheme: AppBarTheme(
backgroundColor: Color(0xFF000000),
iconTheme: IconThemeData(color: Colors.orange), // optional
),
    textTheme: TextTheme(
bodyLarge: TextStyle(color: Colors.white),
),
);


class CalculatorApp extends StatefulWidget {
  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}
  class _CalculatorAppState extends State<CalculatorApp>{
    ThemeMode _themeMode = ThemeMode.dark;

    void _toggleTheme(){
      setState((){
        _themeMode = _themeMode == ThemeMode.dark? ThemeMode.light : ThemeMode.dark;
    });
  }

   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       title: 'Simple Calculator',
       theme: lightMode,
       darkTheme: darkMode,
       themeMode: _themeMode,
       home: CalculatorHome(onToggleTheme: _toggleTheme),
       debugShowCheckedModeBanner: false,
     );
   }
 }

class CalculatorHome extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const CalculatorHome({Key? key, required this.onToggleTheme}) : super(key: key);

  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();

}


class _CalculatorHomeState extends State<CalculatorHome> {
  String _input = '';
  String _result = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _result = '';
      }
      else if (value == '=') {
        try {
          _result = _calculate(_input);
        } catch (e) {
          _result = 'Error';
        }
      }
      else if (value == '⌫') { // You can use '⌫' or '←'
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
        else if (value == '🖩') {
          _input = _input.substring(0, _input.length - 1);
        }
      }
      else {
        _input += value;
      }
    });
  }

  String _calculate(String expression) {
    try {
      ExpressionParser p = GrammarParser();  // Creates a parser Object

      Expression exp = p.parse(expression);   // Parse / reads the string and turn into a math expression

      ContextModel cm = ContextModel();

      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result.toString();
     }
    catch (e) {
      return 'Invalid Error';
    }
  }

  Widget _buildButton(String value) {

    Color getButtonColor(String value) {
      if ('=+-*/'.contains(value)) return Colors.orange;
      if ('%()C⌫'.contains(value)) return Color(0xFF5C5B61);
      return Color(0xFF2B2B2D);
    }
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(value),
          style: ElevatedButton.styleFrom(
            backgroundColor: getButtonColor(value),
            padding: EdgeInsets.all(21), // optional: make buttons bigger
            shape: RoundedRectangleBorder(          // optional: rounded corners
              borderRadius: BorderRadius.circular(55),
            ),
          ),
          child: Text(value, style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold,color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> values) {
    return Row(
      children: values.map((val) => _buildButton(val)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold (
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(

            leading: Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () => showPopover(
                      context: context,
                      bodyBuilder: (context) => menuItem(),
                  width: 250,
                  height: 150,
                  backgroundColor: Colors.orange.shade300,
                  direction: PopoverDirection.bottom
                  ),
                  child: (Icon(Icons.more_vert,color: Colors.orange)),
                );
              }
            ),
            actions: [
              IconButton(
                onPressed: widget.onToggleTheme,
                icon: Icon(Icons.nightlight),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.all(22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(_input, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color,fontSize: 40,fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(_result, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color,fontSize: 30)),
                      ],
                    ),
                  ),
                ),
                _buildButtonRow(['C', '%', '⌫', '/']),
                _buildButtonRow(['7', '8', '9', '*']),
                _buildButtonRow(['4', '5', '6', '-']),
                _buildButtonRow(['1', '2', '3', '+']),
                _buildButtonRow(['#', '0', '.', '=']),
              ],
            ),
          ),
      ),
    );
  }
}
