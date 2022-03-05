import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_service_provider/provider/location_provider.dart';
import 'package:vehicle_service_provider/screens/input_screen.dart';
import 'package:vehicle_service_provider/widgets/app_drawer.dart';
import 'package:vehicle_service_provider/widgets/location_item.dart';

class MyLocations extends StatelessWidget {
  static const routeName = "/my-locations";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("My Locations"),
      ),
      body: FutureBuilder(
        future:
            Provider.of<LocationProvider>(context, listen: false).fetchAndSet(true),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : LocationItem()
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () =>
              Navigator.of(context).pushNamed(InputScreen.routeName)),
    );
  }
}
