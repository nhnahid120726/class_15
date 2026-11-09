
import 'dart:ui';
import 'package:flutter/material.dart';


class chategtpai extends StatefulWidget {
  const chategtpai({super.key});

  @override
  State<chategtpai> createState() =>
      _CalculatorScreenState();
}

class _CalculatorScreenState extends State<chategtpai>
    with SingleTickerProviderStateMixin {

  final firstController = TextEditingController();
  final secondController = TextEditingController();

  late AnimationController glowController;

  String result = "0";
  String expression = "Your result will appear here";
  String selectedOperation = "";

  @override
  void initState() {
    super.initState();

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    glowController.dispose();
    super.dispose();
  }

  void calculate(String op) {
    double? a = double.tryParse(firstController.text);
    double? b = double.tryParse(secondController.text);

    if (a == null || b == null) {
      showMessage("Please enter valid numbers");
      return;
    }

    if (op == "/" && b == 0) {
      showMessage("Cannot divide by zero");
      return;
    }

    double answer = 0;

    switch (op) {
      case "+":
        answer = a + b;
        break;
      case "-":
        answer = a - b;
        break;
      case "*":
        answer = a * b;
        break;
      case "/":
        answer = a / b;
        break;
    }

    setState(() {
      result = answer == answer.toInt()
          ? answer.toInt().toString()
          : answer.toString();

      expression = "$a $op $b";
      selectedOperation = op;
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF292943),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void clearAll() {
    firstController.clear();
    secondController.clear();

    setState(() {
      result = "0";
      expression = "Your result will appear here";
      selectedOperation = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090B1A),
      body: Stack(
        children: [
          // BACKGROUND GLOW
          Positioned(
            top: -100,
            left: -80,
            child: glowCircle(
              280,
              const Color(0xFF7B35FF),
            ),
          ),

          Positioned(
            bottom: -100,
            right: -80,
            child: glowCircle(
              280,
              const Color(0xFF00C6FF),
            ),
          ),

          Positioned(
            top: 300,
            right: -100,
            child: glowCircle(
              200,
              const Color(0xFFFF3CAC),
            ),
          ),

          // BACKGROUND CONTENT
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 430,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // HEADER
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF9D50FF),
                                  Color(0xFF4776FF),
                                ],
                              ),
                              borderRadius:
                              BorderRadius.circular(17),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9147FF)
                                      .withOpacity(0.4),
                                  blurRadius: 25,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.calculate_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 14),

                          const Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "NEXUS",
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3,
                                ),
                              ),
                              Text(
                                "SMART CALCULATOR",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF9B9CB8),
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 38),

                      // MAIN GLASS CARD
                      GlassCard(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Calculator",
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                IconButton(
                                  onPressed: clearAll,
                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    color: Color(0xFFB7A0FF),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // INPUT ONE
                            glassInput(
                              controller: firstController,
                              label: "FIRST NUMBER",
                              icon: Icons.looks_one_rounded,
                            ),

                            const SizedBox(height: 17),

                            // INPUT TWO
                            glassInput(
                              controller: secondController,
                              label: "SECOND NUMBER",
                              icon: Icons.looks_two_rounded,
                            ),

                            const SizedBox(height: 30),

                            const Text(
                              "CHOOSE OPERATION",
                              style: TextStyle(
                                color: Color(0xFF9698B6),
                                fontSize: 11,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 17),

                            Row(
                              children: [
                                Expanded(
                                  child: operationButton(
                                    "+",
                                    "ADD",
                                    const Color(0xFFB65CFF),
                                  ),
                                ),
                                const SizedBox(width: 13),
                                Expanded(
                                  child: operationButton(
                                    "-",
                                    "SUBTRACT",
                                    const Color(0xFFFF668C),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 13),

                            Row(
                              children: [
                                Expanded(
                                  child: operationButton(
                                    "*",
                                    "MULTIPLY",
                                    const Color(0xFF00D5C0),
                                  ),
                                ),
                                const SizedBox(width: 13),
                                Expanded(
                                  child: operationButton(
                                    "/",
                                    "DIVIDE",
                                    const Color(0xFF4B9DFF),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            // RESULT GLASS PANEL
                            AnimatedBuilder(
                              animation: glowController,
                              builder: (context, child) {
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(23),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(23),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF34245D),
                                        Color(0xFF171B39),
                                        Color(0xFF182B50),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Color.lerp(
                                        const Color(0xFF9D65FF),
                                        const Color(0xFF00D5FF),
                                        glowController.value,
                                      )!,
                                      width: 1.4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF8B5CFF)
                                            .withOpacity(
                                          0.12 +
                                              glowController.value *
                                                  0.15,
                                        ),
                                        blurRadius: 25,
                                      ),
                                    ],
                                  ),
                                  child: child,
                                );
                              },
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.auto_awesome,
                                        size: 16,
                                        color: Color(0xFFC19AFF),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "CALCULATION RESULT",
                                        style: TextStyle(
                                          fontSize: 11,
                                          letterSpacing: 2,
                                          color: Color(0xFFC7B8FF),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 17),

                                  AnimatedSwitcher(
                                    duration: const Duration(
                                      milliseconds: 500,
                                    ),
                                    transitionBuilder:
                                        (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      result,
                                      key: ValueKey(result),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 43,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    expression,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF9FA7D1),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 22),

                            // CLEAR BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: clearAll,
                                icon: const Icon(
                                  Icons.delete_outline,
                                ),
                                label: const Text(
                                  "CLEAR ALL",
                                  style: TextStyle(
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                  const Color(0xFFBCA8FF),
                                  side: const BorderSide(
                                    color: Color(0xFF68528E),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: Color(0xFFB77CFF),
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "POWERED BY FLUTTER",
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF8588A8),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BACKGROUND GLOW CIRCLE
  Widget glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 100,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }

  // GLASS INPUT
  Widget glassInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 12,
          sigmaY: 12,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.055),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: Colors.white.withOpacity(0.13),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType:
            const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                color: Color(0xFF9699B9),
                fontSize: 11,
                letterSpacing: 1.5,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFFB78AFF),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // NEON OPERATION BUTTON
  Widget operationButton(
      String symbol,
      String label,
      Color color,
      ) {
    bool isSelected = selectedOperation == symbol;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 91,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(isSelected ? 0.30 : 0.15),
            color.withOpacity(0.045),
          ],
        ),
        border: Border.all(
          color: color.withOpacity(isSelected ? 0.9 : 0.35),
          width: isSelected ? 1.8 : 1,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: color.withOpacity(0.22),
              blurRadius: 18,
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(19),
          onTap: () => calculate(symbol),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.2 : 1,
                duration: const Duration(milliseconds: 250),
                child: Text(
                  symbol == "*" ? "×" :
                  symbol == "/" ? "÷" :
                  symbol == "-" ? "−" : "+",
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// REUSABLE GLASS CARD
class GlassCard extends StatelessWidget {
  final Widget child;

  const GlassCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 22,
          sigmaY: 22,
        ),
        child: Container(
          padding: const EdgeInsets.all(23),
          decoration: BoxDecoration(
            color: const Color(0xFF17192E)
                .withOpacity(0.82),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.13),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 35,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
