import 'package:flutter/material.dart';

class class_test extends StatefulWidget {
  const class_test({super.key});

  @override
  State<class_test> createState() => _class_testState();
}

class _class_testState extends State<class_test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Basic Calculator", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Card(
              child: Padding(padding: EdgeInsetsGeometry.all(5),
              child: Column(
                children: [
                  TextField(
                    
                    decoration: InputDecoration(
                      label: Text("Enter Height"),
                      prefixIcon: Icon(Icons.straighten),
                      fillColor: Colors.blueGrey.shade100,
                      hoverColor: Colors.amber
                    ),
                    textAlignVertical: TextAlignVertical(y: 0.5),

                  ),
                  SizedBox(height: 30,),
                  TextField(),
                  Row(
                    children: [

                    ],
                  ),

                ],
              ),),
            )
          ],
        ),
      ),
    );
  }
}
