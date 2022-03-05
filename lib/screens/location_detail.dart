import 'package:flutter/material.dart';
import 'package:vehicle_service_provider/provider/location_provider.dart';

class LocationDetail extends StatelessWidget {
  final Location item;

  LocationDetail(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Detail"),
      ),
      body: Column(

        children: [
          SizedBox(height: 20,),
          Container(
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
              ),
            ),
            width: double.infinity,
          ),
          SizedBox(
            height: 30,
          ),
          Text(item.address,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 27,
              )),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Name :",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  )),
              Text(item.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                  )),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Contact Number :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Text("${item.no}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                    )),
              ],
            ),
        ],
      ),
    );
  }
}
