import 'package:expense_tracker_hn/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key, required this.onValueSelected});

  final ValueChanged<double> onValueSelected;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  double _currentValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('calculator')),
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            tooltip: context.tr('apply'),
            onPressed: () {
              widget.onValueSelected(_currentValue);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SimpleCalculator(
        value: _currentValue,
        hideExpression: true,
        onChanged: (key, value, expression) {
          setState(() {
            _currentValue = value ?? 0.0;
          });
        },
      ),
    );
  }
}
