import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_project/components/app_drawer.dart';
import 'package:weather_app_project/components/location_list_element.dart';
import 'package:weather_app_project/components/network_utilities.dart';
import 'package:weather_app_project/models/location.dart';

class CitySearchPage extends StatefulWidget {
  const CitySearchPage({ Key? key, this.isHomePage = false }): super(key: key);

  final bool isHomePage;

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {

  List<Location> locations = [];

  TextEditingController cityController = TextEditingController();

  Future<void> _getGeoData() async {
    var response = await NetworkUtility.fetchGeolocation(cityController.text);
    if (response != null) {
      setState(() {
        locations = response;
      });
    }
  }

  Future<void> _addNewCity(Location place) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Get List of all Locations
      List<String>? allLocations = prefs.getStringList("locations");
      // Parse new Location to String
      String placeJson = locationToJson(place);
      int placeIndex = 0;
      // Check if List exist
      if (allLocations != null) {
        // Check if List already contains Location
        if (allLocations.contains(placeJson)) {
          // List already have this place
          placeIndex = allLocations.indexOf(placeJson);
        } else {
          allLocations.add(placeJson);
          placeIndex = allLocations.length;
        }
      } else {
        // List is null
        allLocations = List<String>.empty(growable: true);
        allLocations.add(placeJson);
      }
      // Update list in local storage
      prefs.setStringList("locations", allLocations);

      // Set new location as default
      prefs.setInt("default_city", placeIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Center(child: Text("Search your location")),
        actions: [Container(width: 50,),],
        elevation: 0,
      ),
      drawer: (widget.isHomePage ? const AppDrawer() : null),
      body: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 900,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: cityController,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                decoration: InputDecoration(
                  hintText: "i.e. Seattle, US, Washington...",
                  hintStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _getGeoData,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.search),
                    Text("Search"),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.place),
                    Text("Get current location"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  locations.isNotEmpty ? 'Click on your place' : '',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (context, index) => LocationListElement(
                      location: locations[index],
                      onPress: () {
                        _addNewCity(locations[index]);
                        Navigator.pushNamed(context, '/home');
                      },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}