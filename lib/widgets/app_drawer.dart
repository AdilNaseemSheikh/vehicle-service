import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_service_provider/provider/auth.dart';
import 'package:vehicle_service_provider/screens/my_locations.dart';
import 'package:vehicle_service_provider/screens/user_auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hi"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).pushNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text("Manage My Locations"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(MyLocations.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              // Navigator.of(context).pushNamed(MyLocations.routeName);
              Provider.of<Auth>(context,listen: false).logout;
              Navigator.of(context).pushNamed(UserAuth.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text("Help"),
            onTap: () {
              Navigator.of(context).pushNamed(MyLocations.routeName);
            },
          ),
        ],
      ),
    );
  }
}
