import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  void setStringInPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref
        .setString('name', 'James Bond')
        .then(
          (value) => print("Value saved: $value"), 
        );
  }

  void setIntInPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref
        .setInt('age', 40)
        .then(
          (value) => print("Value saved: $value"), 
        );
  }

  void getStringInPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? name = await pref.getString('name');
    print("Name from preference: $name");
  }

  void getIntInPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? age = await pref.getInt('age');
    print("Name from preference: $age");
  }

  void removeData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('name');
    pref.remove('age');
    print("Data removed successfully");
  }
}
