import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_service_provider/provider/location_provider.dart';
import 'package:vehicle_service_provider/screens/map_screen.dart';
import 'package:vehicle_service_provider/widgets/app_drawer.dart';
import 'package:vehicle_service_provider/widgets/location_item.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: FutureBuilder(
          future: Provider.of<LocationProvider>(context,listen: false).fetchAndSet(false),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else
              return MapScreen(isSelecting: false,);
          },
        ));
  }
}
