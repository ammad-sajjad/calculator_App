import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class CalculatorHome extends StatefulWidget {
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
            padding: EdgeInsets.all(20),            // optional: make buttons bigger
            shape: RoundedRectangleBorder(          // optional: rounded corners
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text(value, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white)),
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
      padding: const EdgeInsets.all(14.0),
      child: Scaffold (
        backgroundColor: Color(0xFF000000),
        appBar: AppBar(title: Text("",style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF000000),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_input, style: TextStyle(fontSize: 40, color: Colors.white,fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(_result, style: TextStyle(fontSize: 30, color: Colors.white)),
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
    );
  }
}
