import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculator")
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Nahid Hasan'),
              accountEmail: Text('nahid@gmail.com'),

            ),
          ],
        ),
      ),

      endDrawer: Drawer(),

      body: Text("i am nahid hasan"),

      bottomNavigationBar: NavigationBar(
        destinations: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add_a_photo)),
          IconButton(onPressed: () {}, icon: Icon(Icons.file_open)),
        ],
      ),

      bottomSheet: Container(
        height: 100,
          child: Column(children: [Text("End Bar Sheet")])),
    );
  }
}
