import 'package:flutter/material.dart';
import 'dart:math' as math;


// Animated gradient background
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                math.cos(_controller.value * 2 * math.pi),
                math.sin(_controller.value * 2 * math.pi),
              ),
              end: Alignment(
                -math.cos(_controller.value * 2 * math.pi),
                -math.sin(_controller.value * 2 * math.pi),
              ),
              colors: [
                Color.lerp(
                  const Color(0xFF667eea),
                  const Color(0xFF6C63FF),
                  _controller.value,
                )!,
                Color.lerp(
                  const Color(0xFF764ba2),
                  const Color(0xFFf093fb),
                  _controller.value,
                )!,
                Color.lerp(
                  const Color(0xFFf093fb),
                  const Color(0xFFf5576c),
                  _controller.value,
                )!,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

// Floating particles overlay
class FloatingParticles extends StatefulWidget {
  const FloatingParticles({super.key});

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    final random = math.Random();
    for (int i = 0; i < 20; i++) {
      _particles.add(_Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 6 + 2,
        speed: random.nextDouble() * 0.3 + 0.1,
        opacity: random.nextDouble() * 0.3 + 0.05,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(_particles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  double x, y, size, speed, opacity;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double animationValue;

  _ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.y + animationValue * p.speed) % 1.0;
      final paint = Paint()
        ..color = Colors.white.withOpacity(p.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size * 0.5);
      canvas.drawCircle(
        Offset(p.x * size.width, y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Glassmorphism container
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white.withOpacity(0.15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

// Animated result display
class AnimatedResultDisplay extends StatelessWidget {
  final String result;
  final String operation;

  const AnimatedResultDisplay({
    super.key,
    required this.result,
    required this.operation,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  )),
                  child: child,
                ),
              );
            },
            child: Text(
              operation,
              key: ValueKey(operation),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.7),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.elasticOut,
                ),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Text(
              result,
              key: ValueKey(result),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Modern text field
class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int index;

  const ModernTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0, 1),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.15),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ),
    );
  }
}

// Animated operation button
class OperationButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onPressed;
  final int index;

  const OperationButton({
    super.key,
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.onPressed,
    required this.index,
  });

  @override
  State<OperationButton> createState() => _OperationButtonState();
}

class _OperationButtonState extends State<OperationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 700 + (widget.index * 150)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0, 1),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _tapController.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _tapController.reverse();
          widget.onPressed();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _tapController.reverse();
        },
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: widget.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.gradientColors.first.withOpacity(0.4),
                  blurRadius: _isPressed ? 5 : 15,
                  spreadRadius: _isPressed ? 0 : 1,
                  offset: Offset(0, _isPressed ? 2 : 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Main Home Screen
class arenaai extends StatefulWidget {
  const arenaai({super.key});

  @override
  State<arenaai> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<arenaai> with TickerProviderStateMixin {
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  String _result = "0";
  String _operation = "Enter numbers to calculate";
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  final List<String> _history = [];
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _calculate(String op) {
    final num1 = double.tryParse(_firstController.text);
    final num2 = double.tryParse(_secondController.text);

    if (num1 == null || num2 == null) {
      _shakeController.forward().then((_) => _shakeController.reverse());
      setState(() {
        _result = "Error";
        _operation = "Please enter valid numbers";
      });
      return;
    }

    double res;
    String opLabel;
    String symbol;

    switch (op) {
      case '+':
        res = num1 + num2;
        opLabel = "Addition";
        symbol = "+";
        break;
      case '-':
        res = num1 - num2;
        opLabel = "Subtraction";
        symbol = "-";
        break;
      case '*':
        res = num1 * num2;
        opLabel = "Multiplication";
        symbol = "×";
        break;
      case '/':
        if (num2 == 0) {
          _shakeController.forward().then((_) => _shakeController.reverse());
          setState(() {
            _result = "∞";
            _operation = "Cannot divide by zero!";
          });
          return;
        }
        res = num1 / num2;
        opLabel = "Division";
        symbol = "÷";
        break;
      case '%':
        res = num1 % num2;
        opLabel = "Modulus";
        symbol = "%";
        break;
      case '^':
        res = math.pow(num1, num2).toDouble();
        opLabel = "Power";
        symbol = "^";
        break;
      default:
        return;
    }

    final resultStr = res == res.toInt() ? res.toInt().toString() : res.toStringAsFixed(4);
    final historyEntry = "${num1.toString()} $symbol ${num2.toString()} = $resultStr";

    setState(() {
      _result = resultStr;
      _operation = "$opLabel: ${num1.toString()} $symbol ${num2.toString()}";
      _history.insert(0, historyEntry);
      if (_history.length > 10) _history.removeLast();
    });
  }

  void _clear() {
    setState(() {
      _firstController.clear();
      _secondController.clear();
      _result = "0";
      _operation = "Enter numbers to calculate";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: Stack(
          children: [
            const FloatingParticles(),
            SafeArea(
              child: Column(
                children: [
                  // Custom App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: child,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.calculate_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 800),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: child,
                            );
                          },
                          child: const Text(
                            "Pro Calculator",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() => _showHistory = !_showHistory);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  _showHistory
                                      ? Icons.close_rounded
                                      : Icons.history_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _clear,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _showHistory
                          ? _buildHistoryPanel()
                          : _buildCalculatorPanel(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryPanel() {
    return Padding(
      key: const ValueKey('history'),
      padding: const EdgeInsets.all(20),
      child: GlassContainer(
        child: _history.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history_rounded,
                size: 60,
                color: Colors.white.withOpacity(0.4),
              ),
              const SizedBox(height: 16),
              Text(
                "No history yet",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Start calculating to see history",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        )
            : ListView.separated(
          itemCount: _history.length,
          separatorBuilder: (_, __) => Divider(
            color: Colors.white.withOpacity(0.15),
            height: 1,
          ),
          itemBuilder: (context, index) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        _history[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCalculatorPanel() {
    return SingleChildScrollView(
      key: const ValueKey('calculator'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Result Display
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              final dx = math.sin(_shakeAnimation.value * math.pi * 4) * 10;
              return Transform.translate(
                offset: Offset(dx, 0),
                child: child,
              );
            },
            child: AnimatedResultDisplay(
              result: _result,
              operation: _operation,
            ),
          ),

          const SizedBox(height: 24),

          // Input Fields
          ModernTextField(
            controller: _firstController,
            label: "First Number",
            icon: Icons.looks_one_rounded,
            index: 0,
          ),
          const SizedBox(height: 16),
          ModernTextField(
            controller: _secondController,
            label: "Second Number",
            icon: Icons.looks_two_rounded,
            index: 1,
          ),

          const SizedBox(height: 28),

          // Operation Buttons - Row 1
          Row(
            children: [
              Expanded(
                child: OperationButton(
                  label: "Add",
                  icon: Icons.add_rounded,
                  gradientColors: const [Color(0xFF43e97b), Color(0xFF38f9d7)],
                  onPressed: () => _calculate('+'),
                  index: 0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OperationButton(
                  label: "Subtract",
                  icon: Icons.remove_rounded,
                  gradientColors: const [Color(0xFFf5576c), Color(0xFFff6a88)],
                  onPressed: () => _calculate('-'),
                  index: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Operation Buttons - Row 2
          Row(
            children: [
              Expanded(
                child: OperationButton(
                  label: "Multiply",
                  icon: Icons.close_rounded,
                  gradientColors: const [Color(0xFF667eea), Color(0xFF764ba2)],
                  onPressed: () => _calculate('*'),
                  index: 2,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OperationButton(
                  label: "Divide",
                  icon: Icons.percent_rounded,
                  gradientColors: const [Color(0xFFf093fb), Color(0xFFf5576c)],
                  onPressed: () => _calculate('/'),
                  index: 3,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Operation Buttons - Row 3 (Extra)
          Row(
            children: [
              Expanded(
                child: OperationButton(
                  label: "Modulus",
                  icon: Icons.data_usage_rounded,
                  gradientColors: const [Color(0xFFffecd2), Color(0xFFfcb69f)],
                  onPressed: () => _calculate('%'),
                  index: 4,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OperationButton(
                  label: "Power",
                  icon: Icons.superscript_rounded,
                  gradientColors: const [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
                  onPressed: () => _calculate('^'),
                  index: 5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Clear Button
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value.clamp(0, 1),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: _clear,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.clear_all_rounded,
                          color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Text(
                        "Clear All",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// AnimatedBuilder helper (uses AnimatedWidget pattern)
class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(
      listenable: animation,
      builder: builder,
      child: child,
    );
  }
}

class AnimatedBuilder2 extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder2({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}