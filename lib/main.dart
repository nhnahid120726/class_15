import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Day_16/mbi_calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const HomeScreen(),
    );
  }
}

// ==================== 1. HOME SCREEN ====================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calculator Hub",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Header Icon & Text
            const Icon(
              Icons.calculate_rounded,
              size: 80,
              color: Color(0xFF6C63FF),
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome Back!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Select a calculator tool below to get started",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 45),

            // --- Button 1: Normal Calculator ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6C63FF),
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 4,
                shadowColor: const Color(0xFF6C63FF).withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NormalCalculatorScreen()),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.dialpad_rounded, size: 24),
                  SizedBox(width: 12),
                  Text(
                    "Normal Calculator",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Button 2: BMI Calculator ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 4,
                shadowColor: const Color(0xFF6C63FF).withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BmiCalculatorScreen()),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.monitor_weight_rounded, size: 24),
                  SizedBox(width: 12),
                  Text(
                    "BMI Calculator",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 2. NORMAL CALCULATOR SCREEN ====================
class NormalCalculatorScreen extends StatefulWidget {
  const NormalCalculatorScreen({super.key});

  @override
  State<NormalCalculatorScreen> createState() => _NormalCalculatorScreenState();
}

class _NormalCalculatorScreenState extends State<NormalCalculatorScreen> {
  String output = "0";
  String _output = "0";
  double num1 = 0;
  double num2 = 0;
  String operand = "";

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "CLEAR") {
        _output = "0";
        num1 = 0;
        num2 = 0;
        operand = "";
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "*" || buttonText == "/") {
        num1 = double.parse(output);
        operand = buttonText;
        _output = "0";
      } else if (buttonText == ".") {
        if (_output.contains(".")) {
          return;
        } else {
          _output = _output + buttonText;
        }
      } else if (buttonText == "=") {
        num2 = double.parse(output);
        if (operand == "+") {
          _output = (num1 + num2).toString();
        }
        if (operand == "-") {
          _output = (num1 - num2).toString();
        }
        if (operand == "*") {
          _output = (num1 * num2).toString();
        }
        if (operand == "/") {
          _output = num2 != 0 ? (num1 / num2).toString() : "Error";
        }
        num1 = 0;
        num2 = 0;
        operand = "";
      } else {
        _output = _output == "0" ? buttonText : _output + buttonText;
      }
      output = _output;
    });
  }

  Widget buildButton(String buttonText, Color textColor, Color bgColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.all(22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Normal Calculator", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6C63FF),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Text(
              output,
              style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(children: [buildButton("7", Colors.black87, Colors.white), buildButton("8", Colors.black87, Colors.white), buildButton("9", Colors.black87, Colors.white), buildButton("/", Colors.white, const Color(0xFF6C63FF))]),
                  Row(children: [buildButton("4", Colors.black87, Colors.white), buildButton("5", Colors.black87, Colors.white), buildButton("6", Colors.black87, Colors.white), buildButton("*", Colors.white, const Color(0xFF6C63FF))]),
                  Row(children: [buildButton("1", Colors.black87, Colors.white), buildButton("2", Colors.black87, Colors.white), buildButton("3", Colors.black87, Colors.white), buildButton("-", Colors.white, const Color(0xFF6C63FF))]),
                  Row(children: [buildButton(".", Colors.black87, Colors.white), buildButton("0", Colors.black87, Colors.white), buildButton("CLEAR", Colors.redAccent, Colors.red.shade50), buildButton("+", Colors.white, const Color(0xFF6C63FF))]),
                  Row(children: [buildButton("=", Colors.white, Colors.green)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 3. BMI CALCULATOR SCREEN ====================
class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  double bmi = 0.0;
  String category = "";
  Color resultColor = Colors.grey;
  String healthAdvice = "Enter your metrics to get personalized health insights.";
  bool isMetric = true;

  void calculateBmi() {
    double? height = double.tryParse(heightController.text);
    double? weight = double.tryParse(weightController.text);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter valid height and weight values!"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      if (isMetric) {
        double heightInMeters = height > 3.0 ? height / 100.0 : height;
        if (heightInMeters > 0) {
          bmi = weight / (heightInMeters * heightInMeters);
        }
      } else {
        bmi = (703 * weight) / (height * height);
      }

      if (bmi < 18.5) {
        category = "Underweight";
        resultColor = Colors.blueAccent;
        healthAdvice = "Consider a nutrient-rich, calorie-dense diet and strength training.";
      } else if (bmi >= 18.5 && bmi <= 24.9) {
        category = "Normal Weight";
        resultColor = Colors.green;
        healthAdvice = "Awesome! You have a healthy body weight. Maintain your lifestyle.";
      } else if (bmi >= 25 && bmi <= 29.9) {
        category = "Overweight";
        resultColor = Colors.orangeAccent;
        healthAdvice = "Consider a balanced diet and regular physical activity.";
      } else {
        category = "Obese";
        resultColor = Colors.redAccent;
        healthAdvice = "It's recommended to consult a healthcare professional.";
      }
    });

    FocusScope.of(context).unfocus();
  }

  void resetCalculator() {
    setState(() {
      heightController.clear();
      weightController.clear();
      bmi = 0.0;
      category = "";
      resultColor = Colors.grey;
      healthAdvice = "Enter your metrics to get personalized health insights.";
    });
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BmiCalculator();
  }
}