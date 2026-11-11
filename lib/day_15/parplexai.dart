import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    BasicCalculatorScreen(),
    AgeCalculatorScreen(),
    BmiCalculatorScreen(),
    PercentageCalculatorScreen(),
    CurrencyConverterScreen(),
    DiscountCalculatorScreen(),
    UnitConverterScreen(),
  ];

  final List<String> _titles = const [
    'Basic Calculator',
    'Age Calculator',
    'BMI Calculator',
    'Percentage Calculator',
    'Currency Converter',
    'Discount Calculator',
    'Unit Converter',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Basic',
          ),
          NavigationDestination(
            icon: Icon(Icons.cake_outlined),
            selectedIcon: Icon(Icons.cake),
            label: 'Age',
          ),
          NavigationDestination(
            icon: Icon(Icons.monitor_weight_outlined),
            selectedIcon: Icon(Icons.monitor_weight),
            label: 'BMI',
          ),
          NavigationDestination(
            icon: Icon(Icons.percent_outlined),
            selectedIcon: Icon(Icons.percent),
            label: 'Percent',
          ),
          NavigationDestination(
            icon: Icon(Icons.currency_exchange_outlined),
            selectedIcon: Icon(Icons.currency_exchange),
            label: 'Currency',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_offer_outlined),
            selectedIcon: Icon(Icons.local_offer),
            label: 'Discount',
          ),
          NavigationDestination(
            icon: Icon(Icons.straighten_outlined),
            selectedIcon: Icon(Icons.straighten),
            label: 'Units',
          ),
        ],
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;

  const AppCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class ResultBox extends StatelessWidget {
  final String title;
  final String value;

  const ResultBox({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class BasicCalculatorScreen extends StatefulWidget {
  const BasicCalculatorScreen({super.key});

  @override
  State<BasicCalculatorScreen> createState() => _BasicCalculatorScreenState();
}

class _BasicCalculatorScreenState extends State<BasicCalculatorScreen> {
  final firstController = TextEditingController();
  final secondController = TextEditingController();

  String result = '0';

  double? _getNumber(TextEditingController controller) {
    return double.tryParse(controller.text.trim());
  }

  void calculate(String operation) {
    final first = _getNumber(firstController);
    final second = _getNumber(secondController);

    if (first == null || second == null) {
      setState(() => result = 'Please enter valid numbers');
      return;
    }

    double value;

    switch (operation) {
      case '+':
        value = first + second;
        break;
      case '-':
        value = first - second;
        break;
      case '*':
        value = first * second;
        break;
      case '/':
        if (second == 0) {
          setState(() => result = 'Cannot divide by zero');
          return;
        }
        value = first / second;
        break;
      default:
        value = 0;
    }

    setState(() {
      result = value.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AppCard(
            child: Column(
              children: [
                TextField(
                  controller: firstController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'First Number',
                    prefixIcon: Icon(Icons.looks_one),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: secondController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Second Number',
                    prefixIcon: Icon(Icons.looks_two),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => calculate('+'),
                        child: const Text('Sum (+)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => calculate('-'),
                        child: const Text('Subtract (-)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => calculate('*'),
                        child: const Text('Multiply (*)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => calculate('/'),
                        child: const Text('Divide (/)'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ResultBox(title: 'Result', value: result),
        ],
      ),
    );
  }
}

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime? selectedDate;
  String result = 'Select your date of birth';

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) return;

    final now = DateTime.now();

    int years = now.year - pickedDate.year;
    int months = now.month - pickedDate.month;
    int days = now.day - pickedDate.day;

    if (days < 0) {
      months--;
      days += DateTime(now.year, now.month, 0).day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    setState(() {
      selectedDate = pickedDate;
      result = '$years years, $months months, $days days';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Date of Birth',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: pickDate,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 12),
                        Text(
                          selectedDate == null
                              ? 'Choose date'
                              : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: pickDate,
                    child: const Text('Calculate Age'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ResultBox(title: 'Your Age', value: result),
        ],
      ),
    );
  }
}

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  String result = 'Enter height and weight';

  void calculateBmi() {
    final height = double.tryParse(heightController.text.trim());
    final weight = double.tryParse(weightController.text.trim());

    if (height == null || weight == null || height <= 0) {
      setState(() => result = 'Please enter valid values');
      return;
    }

    final heightInMeter = height / 100;
    final bmi = weight / (heightInMeter * heightInMeter);

    String category;

    if (bmi < 18.5) {
      category = 'Underweight';
    } else if (bmi < 25) {
      category = 'Normal';
    } else if (bmi < 30) {
      category = 'Overweight';
    } else {
      category = 'Obese';
    }

    setState(() {
      result = '${bmi.toStringAsFixed(1)} - $category';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AppCard(
            child: Column(
              children: [
                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    prefixIcon: Icon(Icons.height),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: calculateBmi,
                    child: const Text('Calculate BMI'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ResultBox(title: 'BMI Result', value: result),
        ],
      ),
    );
  }
}

class PercentageCalculatorScreen extends StatefulWidget {
  const PercentageCalculatorScreen({super.key});

  @override
  State<PercentageCalculatorScreen> createState() =>
      _PercentageCalculatorScreenState();
}

class _PercentageCalculatorScreenState
    extends State<PercentageCalculatorScreen> {
  final numberController = TextEditingController();
  final percentController = TextEditingController();

  String result = 'Enter values';

  void calculate() {
    final number = double.tryParse(numberController.text.trim());
    final percent = double.tryParse(percentController.text.trim());

    if (number == null || percent == null) {
      setState(() => result = 'Please enter valid values');
      return;
    }

    final value = (number * percent) / 100;

    setState(() {
      result = value.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AppCard(
            child: Column(
              children: [
                TextField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Number',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: percentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Percentage (%)',
                    prefixIcon: Icon(Icons.percent),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: calculate,
                    child: const Text('Calculate Percentage'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ResultBox(title: 'Percentage Value', value: result),
        ],
      ),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final amountController = TextEditingController();

  String fromCurrency = 'USD';
  String toCurrency = 'BDT';

  String result = '0.00';

  final Map<String, double> rates = {
    'USD': 1,
    'BDT': 110,
    'EUR': 0.92,
    'GBP': 0.79,
    'INR': 83,
  };

  void convert() {
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null) {
      setState(() => result = 'Enter a valid amount');
      return;
    }

    final usdAmount = amount / rates[fromCurrency]!;
    final converted = usdAmount * rates[toCurrency]!;

    setState(() {
      result = converted.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AppCard(
            child: Column(
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: fromCurrency,
                        decoration: const InputDecoration(
                          labelText: 'From',
                        ),
                        items: rates.keys
                            .map(
                              (currency) => DropdownMenuItem(
                            value: currency,
                            child: Text(currency),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          setState(() => fromCurrency = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.swap_horiz, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: toCurrency,
                        decoration: const InputDecoration(
                          labelText: 'To',
                        ),
                        items: rates.keys
                            .map(
                              (currency) => DropdownMenuItem(
                            value: currency,
                            child: Text(currency),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          setState(() => toCurrency = value!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: convert,
                    child: const Text('Convert'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ResultBox(
            title: '$fromCurrency to $toCurrency',
            value: result,
          ),
          const SizedBox(height: 12),
          const Text(
            'Note: Exchange rates are sample rates for learning purposes.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class DiscountCalculatorScreen extends StatefulWidget {
  const DiscountCalculatorScreen({super.key});

  @override
  State<DiscountCalculatorScreen> createState() =>
      _DiscountCalculatorScreenState();
}

class _DiscountCalculatorScreenState extends State<DiscountCalculatorScreen> {
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  String result = 'Enter price and discount';

  void calculate() {
    final price = double.tryParse(priceController.text.trim());
    final discount = double.tryParse(discountController.text.trim());

    if (price == null || discount == null || discount < 0 || discount > 100) {
      setState(() => result = 'Enter valid values');
      return;
    }

    final discountAmount = (price * discount) / 100;
    final finalPrice = price - discountAmount;

    setState(() {
      result =
      'Final Price: ${finalPrice.toStringAsFixed(2)}\nYou Save: ${discountAmount.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AppCard(
            child: Column(
              children: [
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Original Price',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Discount (%)',
                    prefixIcon: Icon(Icons.local_offer),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: calculate,
                    child: const Text('Calculate Discount'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ResultBox(title: 'Discount Result', value: result),
        ],
      ),
    );
  }
}

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final valueController = TextEditingController();

  String fromUnit = 'Meter';
  String toUnit = 'Feet';

  String result = '0';

  final Map<String, double> meterRates = {
    'Meter': 1,
    'Kilometer': 1000,
    'Centimeter': 0.01,
    'Feet': 0.3048,
    'Inch': 0.0254,
  };

  void convert() {
    final value = double.tryParse(valueController.text.trim());

    if (value == null) {
      setState(() => result = 'Enter a valid value');
      return;
    }

    final meters = value * meterRates[fromUnit]!;
    final converted = meters / meterRates[toUnit]!;

    setState(() {
      result = converted.toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AppCard(
            child: Column(
              children: [
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Value',
                    prefixIcon: Icon(Icons.straighten),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: fromUnit,
                        decoration: const InputDecoration(
                          labelText: 'From',
                        ),
                        items: meterRates.keys
                            .map(
                              (unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          setState(() => fromUnit = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.swap_horiz, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: toUnit,
                        decoration: const InputDecoration(
                          labelText: 'To',
                        ),
                        items: meterRates.keys
                            .map(
                              (unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          setState(() => toUnit = value!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: convert,
                    child: const Text('Convert'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ResultBox(
            title: '$fromUnit to $toUnit',
            value: result,
          ),
        ],
      ),
    );
  }
}