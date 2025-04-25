import 'package:demo/preference.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PreferenceManager preferenceHelper = PreferenceManager();
  String? _name;
  int? _age;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      _name = _pref.getString('name');
      _age = _pref.getInt('age');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Preference "),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              child: ElevatedButton(
                onPressed: () {
                  preferenceHelper.setStringInPreference();
                  preferenceHelper.setIntInPreference();
                },
                child: Text(
                  "Save Data",
                  style: TextStyle(backgroundColor: Colors.green),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  preferenceHelper.getStringInPreference();
                  preferenceHelper.getIntInPreference();
                },
                child: Text("Load Data"),
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  preferenceHelper.removeData();
                },
                child: Text("Delete Data"),
              ),
            ),
            
            Container(

            )
          ],
        ),
      ),
    );
  }
}
