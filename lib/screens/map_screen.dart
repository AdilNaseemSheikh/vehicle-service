import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_service_provider/provider/location_provider.dart';
import 'package:vehicle_service_provider/screens/location_detail.dart';

class MapScreen extends StatefulWidget {
  final bool isSelecting;

  // final initialPosition;

  MapScreen({this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> myMarkers = [];
  LatLng pickedLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final myList =
        Provider.of<LocationProvider>(context, listen: false).getItemsList;
    for (int i = 0; i < myList.length; i++) {
      myMarkers.add(
        Marker(
          markerId: MarkerId("${DateTime.now()}"),
          position:
          LatLng(myList[i].latitude, myList[i].longitude),
          infoWindow: InfoWindow(
              title: "${myList[i].title}",
              snippet: "Repair Shop",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => LocationDetail(myList[i]),
                  ),
                );
              }),
        ),
      );
    }
  }

  void selectLocation(LatLng position) {
    setState(() {
      pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isSelecting
        ? Scaffold(
            appBar: AppBar(
              title: Text("Map"),
              actions: [
                if (widget.isSelecting)
                  IconButton(
                      onPressed: pickedLocation == null
                          ? null
                          : () {
                              Navigator.of(context).pop(pickedLocation);
                            },
                      icon: Icon(Icons.check))
              ],
            ),
            body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(32.048916, 72.7064209),
                zoom: 18,
              ),
              onTap: widget.isSelecting ? selectLocation : null,
              markers: pickedLocation == null
                  ? {}
                  : {
                      Marker(
                          markerId: MarkerId("myMarker"),
                          position: pickedLocation),
                    },
            ))
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(32.048916, 72.7064209),
              zoom: 18,
            ),
            onTap: null,
            markers: Set.from(myMarkers),
          );
  }
}
