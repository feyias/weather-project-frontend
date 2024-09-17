import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_project/models/location.dart';

class AppDrawer extends Drawer {
  const AppDrawer({Key? key, this.savedLocations = const []}) : super(key: key);

  Future<void> _changeCity(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('default_city', index);
  }

  final List<Location> savedLocations;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              leading: Icon(
                Icons.home,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                  "HOME",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.people,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                  "ABOUT US",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.contact_page,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                  "CONTACT",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 2.0,
            ),
            SizedBox(
              height: savedLocations.length * 65,
              child: ListView.builder(
                itemCount: savedLocations.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(
                    Icons.place,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                      savedLocations[index].city,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      )
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home');
                    _changeCity(index);
                  },
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                  "Add new location",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/new');
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 2.0,
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                  "SETTINGS",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )
              ),
              onTap: () {
                Navigator.pop(context);
                //_test();
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}