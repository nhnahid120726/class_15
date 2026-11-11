import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class bmi_calcuket extends StatefulWidget {
  const bmi_calcuket({super.key});

  @override
  State<bmi_calcuket> createState() => _bmi_calcuketState();
}

class _bmi_calcuketState extends State<bmi_calcuket> {

  final heightController = TextEditingController();
  final weightController = TextEditingController();

  double bmi = 0;
  String category = "";
  Color resultColor = Colors.grey;

  void calculateBmi() {
    double? height = double.tryParse(heightController.text);
    double? weight = double.tryParse(weightController.text);
    //validation
    if (height == null || weight == null || height < 0 || weight < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid height and weight")),
      );
      return;
    }

    // --- [Kaj kora hoyese]: Height jodi centimeter e ba meter e deya hoy tar calculation handle korar jonno bhalo logic ar baki category gulo add kora hoyese ---
    // Jodi user height meter e dey (ex: 1.75) tahole thik ache, kintu jodi centimeter e dey (ex: 170) tahole meter e convert kore newar safety check:
    double adjustedHeight = height;
    if (height > 3.0) { // Mane user jodi centimeter e value dey (jemon 170)
      adjustedHeight = height / 100.0;
    }

    setState(() {
      // Adjusted height diye BMI calculate kora hocche
      if (adjustedHeight > 0) {
        bmi = weight / (adjustedHeight * adjustedHeight);
      }

      // --- [Kaj kora hoyese]: BMI er category ar color change korar logic complete kora hoyese ---
      if (bmi < 18.5) {
        category = "Underweight";
        resultColor = Colors.blue;
      } else if (bmi >= 18.5 && bmi < 24.9) {
        category = "Normal";
        resultColor = Colors.green;
      } else if (bmi >= 25 && bmi < 29.9) {
        category = "Overweight";
        resultColor = Colors.orange;
      } else {
        category = "Obese";
        resultColor = Colors.red;
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView( // --- [Kaj kora hoyese]: Keyboard asle overflow avoid korar jonno SingleChildScrollView use kora hoyese ---
          child: Column(
            children: [
              const Text(
                "Calculate Your BMI",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 25),

              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: "Height(meter or cm)", // --- [Kaj kora hoyese]: Label updated to support both meter/cm smoothly ---
                  hintText: "ex:170 or 1.7",
                  prefixIcon: Icon(Icons.height),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: "weight(KG)",
                  hintText: "ex:60",
                  prefixIcon: Icon(Icons.monitor_weight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // --- [Kaj kora hoyese]: ElevatedButton er onPressed e calculateBmi() function call kora hoyese ---
              ElevatedButton(
                onPressed: () {
                  calculateBmi();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Calculate"),
                    SizedBox(width: 8),
                    Icon(Icons.send),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // --- [Kaj kora hoyese]: Card design complete kora hoyese jate calculate korar por BMI score ar Category show kore ---
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const Text(
                        "Your Score",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        bmi.toStringAsFixed(1), // BMI value 1 decimal point porjonto dekhabe
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: resultColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        category.isEmpty ? "Enter height & weight" : category,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: resultColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}