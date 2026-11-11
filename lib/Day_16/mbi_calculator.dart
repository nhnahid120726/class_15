import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({super.key});

  @override
  State<BmiCalculator> createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator>
    with TickerProviderStateMixin {
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  double bmi = 0;
  String category = "";
  String healthTip = "";
  IconData categoryIcon = Icons.hourglass_empty;
  Color resultColor = Colors.grey;
  bool hasResult = false;
  bool isDarkMode = false;

  // Animation Controllers
  late AnimationController _bmiAnimationController;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _gaugeController;
  late Animation<double> _bmiAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _gaugeAnimation;

  // Gender selection
  String selectedGender = "male";

  // Unit toggle
  bool isMetric = true; // true = metric (kg/cm), false = imperial (lbs/inches)

  @override
  void initState() {
    super.initState();

    _bmiAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _bmiAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _bmiAnimationController, curve: Curves.easeOutCubic),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _gaugeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _gaugeAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _gaugeController, curve: Curves.elasticOut),
    );
  }

  // ========== COLOR SCHEME ==========
  Color get primaryColor => const Color(0xFF6C63FF);
  Color get secondaryColor => const Color(0xFF3F3D56);

  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryColor, const Color(0xFF8B83FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get backgroundGradient => isDarkMode
      ? const LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  )
      : const LinearGradient(
    colors: [Color(0xFFF8F9FE), Color(0xFFEEEFF5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  Color get cardColor => isDarkMode ? const Color(0xFF222244) : Colors.white;
  Color get textPrimary => isDarkMode ? Colors.white : const Color(0xFF2D2D3A);
  Color get textSecondary =>
      isDarkMode ? Colors.white60 : const Color(0xFF9E9EAF);

  // ========== BMI CALCULATION ==========
  void calculateBmi() {
    double? height = double.tryParse(heightController.text);
    double? weight = double.tryParse(weightController.text);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      _showModernSnackBar("Please enter valid height and weight!", Icons.error_outline);
      return;
    }

    // Convert imperial to metric if needed
    if (!isMetric) {
      height = height * 2.54; // inches to cm
      weight = weight * 0.453592; // lbs to kg
    }

    double adjustedHeight = height;
    if (height > 3.0) {
      adjustedHeight = height / 100.0;
    }

    if (adjustedHeight <= 0) return;

    double newBmi = weight / (adjustedHeight * adjustedHeight);

    setState(() {
      hasResult = true;

      _bmiAnimation = Tween<double>(begin: bmi, end: newBmi).animate(
        CurvedAnimation(parent: _bmiAnimationController, curve: Curves.easeOutCubic),
      );

      // Gauge animation: map BMI to 0.0 - 1.0 range (BMI 10-40 range)
      double gaugeValue = ((newBmi - 10) / 30).clamp(0.0, 1.0);
      _gaugeAnimation = Tween<double>(
        begin: 0,
        end: gaugeValue,
      ).animate(
        CurvedAnimation(parent: _gaugeController, curve: Curves.elasticOut),
      );

      bmi = newBmi;

      if (bmi < 16) {
        category = "Severely Underweight";
        resultColor = const Color(0xFF2196F3);
        categoryIcon = Icons.sentiment_very_dissatisfied;
        healthTip =
        "You are severely underweight. Please consult a doctor and consider a nutrition-rich diet plan.";
      } else if (bmi < 18.5) {
        category = "Underweight";
        resultColor = const Color(0xFF42A5F5);
        categoryIcon = Icons.sentiment_dissatisfied;
        healthTip =
        "Try to increase your calorie intake with healthy foods like nuts, avocados, and whole grains.";
      } else if (bmi < 25) {
        category = "Normal Weight ✨";
        resultColor = const Color(0xFF4CAF50);
        categoryIcon = Icons.sentiment_very_satisfied;
        healthTip =
        "Great job! Maintain your healthy lifestyle with balanced diet and regular exercise.";
      } else if (bmi < 30) {
        category = "Overweight";
        resultColor = const Color(0xFFFF9800);
        categoryIcon = Icons.sentiment_neutral;
        healthTip =
        "Consider increasing physical activity and reducing processed food intake.";
      } else if (bmi < 35) {
        category = "Obese (Class I)";
        resultColor = const Color(0xFFFF5722);
        categoryIcon = Icons.sentiment_dissatisfied;
        healthTip =
        "It's recommended to consult a healthcare professional for a personalized plan.";
      } else {
        category = "Obese (Class II+)";
        resultColor = const Color(0xFFF44336);
        categoryIcon = Icons.warning_amber_rounded;
        healthTip =
        "Please seek medical advice. Focus on gradual lifestyle changes for long-term health.";
      }
    });

    _bmiAnimationController.reset();
    _bmiAnimationController.forward();

    _gaugeController.reset();
    _gaugeController.forward();

    _slideController.reset();
    _slideController.forward();

    _pulseController.repeat(reverse: true);

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Dismiss keyboard
    FocusScope.of(context).unfocus();
  }

  void resetCalculator() {
    setState(() {
      heightController.clear();
      weightController.clear();
      bmi = 0;
      category = "";
      healthTip = "";
      resultColor = Colors.grey;
      hasResult = false;
    });
    _bmiAnimationController.reset();
    _pulseController.reset();
    _gaugeController.reset();
    HapticFeedback.lightImpact();
  }

  void _showModernSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFF5252),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 8,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    _bmiAnimationController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    _gaugeController.dispose();
    super.dispose();
  }

  // ========== BUILD ==========
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: backgroundGradient),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          _buildHeaderSection(),
                          const SizedBox(height: 24),
                          _buildGenderSelector(),
                          const SizedBox(height: 20),
                          _buildUnitToggle(),
                          const SizedBox(height: 20),
                          _buildInputCard(),
                          const SizedBox(height: 24),
                          _buildActionButtons(),
                          const SizedBox(height: 24),
                          if (hasResult) ...[
                            _buildGaugeMeter(),
                            const SizedBox(height: 20),
                            _buildResultCard(),
                            const SizedBox(height: 16),
                            _buildHealthTipCard(),
                            const SizedBox(height: 16),
                            _buildBmiRangeTable(),
                          ] else
                            _buildEmptyState(),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== APP BAR ==========
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo/Brand
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.monitor_heart, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BMI Pro",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    "Health Calculator",
                    style: TextStyle(fontSize: 11, color: textSecondary),
                  ),
                ],
              ),
            ],
          ),
          // Dark mode toggle
          GestureDetector(
            onTap: () {
              setState(() => isDarkMode = !isDarkMode);
              HapticFeedback.selectionClick();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white12 : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDarkMode ? Colors.amber : Colors.blueGrey,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== HEADER ==========
  Widget _buildHeaderSection() {
    return Column(
      children: [
        Text(
          "Know Your Health Score",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Enter your measurements to calculate BMI",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: textSecondary, height: 1.4),
        ),
      ],
    );
  }

  // ========== GENDER SELECTOR ==========
  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(child: _genderCard("male", Icons.male, "Male")),
        const SizedBox(width: 16),
        Expanded(child: _genderCard("female", Icons.female, "Female")),
      ],
    );
  }

  Widget _genderCard(String gender, IconData icon, String label) {
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() => selectedGender = gender);
        HapticFeedback.selectionClick();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? null : cardColor,
          gradient: isSelected ? primaryGradient : null,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? null
              : Border.all(
            color: isDarkMode ? Colors.white12 : Colors.grey.shade200,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 36,
              color: isSelected ? Colors.white : textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== UNIT TOGGLE ==========
  Widget _buildUnitToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white10 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(child: _unitTab("Metric (kg/cm)", true)),
          Expanded(child: _unitTab("Imperial (lbs/in)", false)),
        ],
      ),
    );
  }

  Widget _unitTab(String label, bool metric) {
    bool isActive = isMetric == metric;
    return GestureDetector(
      onTap: () {
        setState(() => isMetric = metric);
        HapticFeedback.selectionClick();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive ? primaryGradient : null,
          borderRadius: BorderRadius.circular(11),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: primaryColor.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : textSecondary,
          ),
        ),
      ),
    );
  }

  // ========== INPUT CARD ==========
  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildModernTextField(
            controller: heightController,
            label: isMetric ? "Height" : "Height",
            hint: isMetric ? "e.g., 170" : "e.g., 67",
            suffix: isMetric ? "cm" : "inches",
            icon: Icons.straighten_rounded,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: weightController,
            label: isMetric ? "Weight" : "Weight",
            hint: isMetric ? "e.g., 65" : "e.g., 143",
            suffix: isMetric ? "kg" : "lbs",
            icon: Icons.fitness_center_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String suffix,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white.withOpacity(0.05) : const Color(0xFFF5F5FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDarkMode ? Colors.white12 : Colors.grey.shade200,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: textSecondary.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              suffixText: suffix,
              suffixStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ========== ACTION BUTTONS ==========
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Calculate Button
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: calculateBmi,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calculate_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    "Calculate BMI",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Reset Button
        GestureDetector(
          onTap: resetCalculator,
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? Colors.white12 : Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.refresh_rounded,
              color: textSecondary,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  // ========== GAUGE METER ==========
  Widget _buildGaugeMeter() {
    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedBuilder(
        animation: _gaugeController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "BMI Gauge",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: CustomPaint(
                    size: const Size(250, 160),
                    painter: GaugePainter(
                      value: _gaugeAnimation.value,
                      color: resultColor,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // BMI Range Labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _gaugeLabel("10", Colors.blue),
                    _gaugeLabel("18.5", Colors.green),
                    _gaugeLabel("25", Colors.orange),
                    _gaugeLabel("30", Colors.deepOrange),
                    _gaugeLabel("40", Colors.red),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _gaugeLabel(String text, Color color) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
      ],
    );
  }

  // ========== RESULT CARD ==========
  Widget _buildResultCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: AnimatedBuilder(
          animation: _bmiAnimationController,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    resultColor.withOpacity(isDarkMode ? 0.25 : 0.08),
                    resultColor.withOpacity(isDarkMode ? 0.1 : 0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: resultColor.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: resultColor.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Category Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: resultColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(categoryIcon, size: 36, color: resultColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Your BMI",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Animated BMI Value
                  Text(
                    _bmiAnimation.value.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: resultColor,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: resultColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: resultColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: resultColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ========== HEALTH TIP CARD ==========
  Widget _buildHealthTipCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                color: Colors.amber,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Health Tip",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    healthTip,
                    style: TextStyle(
                      fontSize: 13,
                      color: textSecondary,
                      height: 1.5,
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

  // ========== BMI RANGE TABLE ==========
  Widget _buildBmiRangeTable() {
    final ranges = [
      {"range": "< 16", "category": "Severely Underweight", "color": const Color(0xFF2196F3)},
      {"range": "16 - 18.4", "category": "Underweight", "color": const Color(0xFF42A5F5)},
      {"range": "18.5 - 24.9", "category": "Normal", "color": const Color(0xFF4CAF50)},
      {"range": "25 - 29.9", "category": "Overweight", "color": const Color(0xFFFF9800)},
      {"range": "30 - 34.9", "category": "Obese (Class I)", "color": const Color(0xFFFF5722)},
      {"range": "≥ 35", "category": "Obese (Class II+)", "color": const Color(0xFFF44336)},
    ];

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.table_chart_rounded, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  "BMI Classification",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...ranges.map((item) {
              bool isCurrentRange = category.contains(item["category"] as String);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isCurrentRange
                      ? (item["color"] as Color).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isCurrentRange
                      ? Border.all(color: (item["color"] as Color).withOpacity(0.3))
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: item["color"] as Color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item["category"] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isCurrentRange ? FontWeight.w700 : FontWeight.w500,
                          color: isCurrentRange ? item["color"] as Color : textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      item["range"] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isCurrentRange ? item["color"] as Color : textSecondary,
                      ),
                    ),
                    if (isCurrentRange) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_back_rounded,
                        size: 14,
                        color: item["color"] as Color,
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ========== EMPTY STATE ==========
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.monitor_weight_outlined,
              size: 48,
              color: primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Enter your details above",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Your BMI result will appear here",
            style: TextStyle(
              fontSize: 13,
              color: textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ========== ANIMATED BUILDER WIDGET ==========
class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext context, Widget? child) builder;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(
      animation: animation,
      builder: builder,
    );
  }
}

class AnimatedBuilder2 extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;

  const AnimatedBuilder2({
    super.key,
    required Animation<double> animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}

// ========== CUSTOM GAUGE PAINTER ==========
class GaugePainter extends CustomPainter {
  final double value; // 0.0 to 1.0
  final Color color;
  final bool isDarkMode;

  GaugePainter({
    required this.value,
    required this.color,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = math.min(size.width / 2 - 20, size.height - 30);

    // Background arc
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..color = isDarkMode ? Colors.white12 : Colors.grey.shade200;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Gradient segments
    final segments = [
      const Color(0xFF2196F3), // Underweight
      const Color(0xFF4CAF50), // Normal
      const Color(0xFFFF9800), // Overweight
      const Color(0xFFFF5722), // Obese I
      const Color(0xFFF44336), // Obese II
    ];

    for (int i = 0; i < segments.length; i++) {
      final segmentPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.butt
        ..color = segments[i].withOpacity(0.3);

      double startAngle = math.pi + (math.pi / segments.length) * i;
      double sweepAngle = math.pi / segments.length;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        segmentPaint,
      );
    }

    // Active arc
    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: math.pi,
        endAngle: 2 * math.pi,
        colors: [
          Colors.blue,
          Colors.green,
          Colors.orange,
          Colors.red,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * value,
      false,
      activePaint,
    );

    // Needle indicator
    double needleAngle = math.pi + (math.pi * value);
    double needleLength = radius - 5;
    Offset needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    // Needle shadow
    final needleShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center + const Offset(2, 2), needleEnd + const Offset(2, 2), needleShadowPaint);

    // Needle
    final needlePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleEnd, needlePaint);

    // Center circle
    final centerDotPaint = Paint()..color = color;
    canvas.drawCircle(center, 8, centerDotPaint);

    final innerDotPaint = Paint()..color = isDarkMode ? const Color(0xFF222244) : Colors.white;
    canvas.drawCircle(center, 4, innerDotPaint);
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}