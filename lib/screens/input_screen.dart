import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_service_provider/helpers/location_helper.dart';
import 'package:vehicle_service_provider/provider/auth.dart';
import 'package:vehicle_service_provider/provider/location_provider.dart'
    show LocationProvider;
import 'package:vehicle_service_provider/screens/map_screen.dart';
import 'package:vehicle_service_provider/widgets/app_drawer.dart';

class InputScreen extends StatefulWidget {
  static const routeName = "/input";

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String imageUrl;
  double selectedLat;
  double selectedLng;
  final cellInput = TextEditingController();
  final titleInput = TextEditingController();
  final nameInput = TextEditingController();
  bool isLoading = false;

  void showPreview(double lat, double lng) {
    setState(() {
      imageUrl = LocationHelper.getImagePreview(lat, lng);
    });
  }

  Future<void> _currentLocation() async {
    LocationData locData = await Location().getLocation();
    selectedLat = locData.latitude;
    selectedLng = locData.longitude;
    showPreview(selectedLat, selectedLng);
  }

  Future<void> _openMap() async {
    final selectedLocation = await Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => MapScreen(isSelecting: true)));
    selectedLat = selectedLocation.latitude;
    selectedLng = selectedLocation.longitude;
    showPreview(selectedLat, selectedLng);
  }

  Future<void> submit(context) async {
    if (selectedLng == null ||
        titleInput.text.isEmpty ||
        cellInput.text.isEmpty) {
      print("please fill all the fields");
      return;
    }
    setState(() {
      isLoading = true;
    });

    num cellInputText = num.parse(cellInput.text);
    String titleInputText = titleInput.text;
    String nameInputText = nameInput.text;
    String address = await LocationHelper.getAddress(selectedLat, selectedLng);

    await Provider.of<LocationProvider>(context, listen: false).addLocation(
        name: nameInputText,
        lat: selectedLat,
        long: selectedLng,
        address: address,
        number: cellInputText,
        locTitle: titleInputText);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Location"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: "Title"),
                      controller: titleInput,
                      keyboardType: TextInputType.text,
                      onSubmitted: (ctx) => submit(context),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Name of owner"),
                      controller: nameInput,
                      keyboardType: TextInputType.text,
                      onSubmitted: (ctx) => submit(context),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "cell no"),
                      controller: cellInput,
                      keyboardType: TextInputType.phone,
                      onSubmitted: (ctx) => submit(context),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      width: double.infinity,
                      height: 170,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.grey)),
                      child: imageUrl == null
                          ? Center(
                              child: Text(
                                "No location Selected",
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton.icon(
                            label: Text("Use Current Location"),
                            icon: Icon(Icons.location_pin),
                            textColor: Theme.of(context).primaryColor,
                            onPressed: _currentLocation),
                        FlatButton.icon(
                          label: Text("Choose from Map"),
                          onPressed: _openMap,
                          textColor: Theme.of(context).primaryColor,
                          icon: Icon(Icons.map_outlined),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                          child: Text("Add"),
                          onPressed: () => submit(context)),
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}
