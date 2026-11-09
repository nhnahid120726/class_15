import 'package:flutter/material.dart';

class geminiai extends StatefulWidget {
  const geminiai({super.key});

  @override
  State<geminiai> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<geminiai> {
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();

  String _result = "0";
  bool _isError = false;

  void _calculate(String operation) {
    FocusScope.of(context).unfocus(); // Hide keyboard on tap

    double? num1 = double.tryParse(_num1Controller.text);
    double? num2 = double.tryParse(_num2Controller.text);

    if (num1 == null || num2 == null) {
      setState(() {
        _result = "Please enter valid numbers";
        _isError = true;
      });
      return;
    }

    double res = 0;
    switch (operation) {
      case '+':
        res = num1 + num2;
        break;
      case '-':
        res = num1 - num2;
        break;
      case '*':
        res = num1 * num2;
        break;
      case '/':
        if (num2 == 0) {
          setState(() {
            _result = "Cannot divide by zero";
            _isError = true;
          });
          return;
        }
        res = num1 / num2;
        break;
    }

    setState(() {
      // Format to remove trailing .0 if integer result
      _result = res % 1 == 0 ? res.toInt().toString() : res.toStringAsFixed(2);
      _isError = false;
    });
  }

  @override
  void dispose() {
    _num1Controller.dispose();
    _num2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade800, Colors.deepPurple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Card(
                elevation: 12,
                shadowColor: Colors.black45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Title
                      const Text(
                        "Pro Calculator",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // First Number Input
                      TextField(
                        controller: _num1Controller,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          labelText: "First Number",
                          labelStyle: TextStyle(color: Colors.grey.shade700),
                          prefixIcon: const Icon(Icons.looks_one, color: Colors.deepPurple),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Second Number Input
                      TextField(
                        controller: _num2Controller,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          labelText: "Second Number",
                          labelStyle: TextStyle(color: Colors.grey.shade700),
                          prefixIcon: const Icon(Icons.looks_two, color: Colors.deepPurple),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Operation Buttons Row 1
                      Row(
                        children: [
                          Expanded(
                            child: _buildOperationButton(
                              label: "Sum (+)",
                              icon: Icons.add,
                              onPressed: () => _calculate('+'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildOperationButton(
                              label: "Sub (-)",
                              icon: Icons.remove,
                              onPressed: () => _calculate('-'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Operation Buttons Row 2
                      Row(
                        children: [
                          Expanded(
                            child: _buildOperationButton(
                              label: "Multiply (×)",
                              icon: Icons.close,
                              onPressed: () => _calculate('*'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildOperationButton(
                              label: "Div (÷)",
                              icon: Icons.percent,
                              onPressed: () => _calculate('/'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Animated Result Container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _isError ? Colors.red.shade50 : Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isError ? Colors.red.shade200 : Colors.deepPurple.shade100,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "RESULT",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: _isError ? Colors.red : Colors.deepPurple.shade400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return ScaleTransition(scale: animation, child: child);
                              },
                              child: Text(
                                _result,
                                key: ValueKey<String>(_result),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: _isError ? 20 : 36,
                                  fontWeight: FontWeight.bold,
                                  color: _isError ? Colors.red.shade700 : Colors.deepPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for custom styled buttons
  Widget _buildOperationButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(vertical: 14),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}