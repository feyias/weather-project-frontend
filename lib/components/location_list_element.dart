import 'package:flutter/material.dart';
import 'package:weather_app_project/models/location.dart';

class LocationListElement extends StatelessWidget {
  const LocationListElement({
    Key? key,
    required this.location,
    required this.onPress,
  }) : super(key: key);

  final Location location;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onPress,
          horizontalTitleGap: 0,
          leading: Icon(Icons.place, color: Theme.of(context).primaryColor),
          title: Text(
            "${location.city}, "
            "${location.country}"
            "${location.state == null ? '' : ', '}"
            "${location.state ?? ''}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Divider(
          height: 2,
          thickness: 2,
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
