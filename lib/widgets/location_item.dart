import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_service_provider/helpers/location_helper.dart';
import 'package:vehicle_service_provider/provider/location_provider.dart';

class LocationItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold.of(context);
    return Consumer<LocationProvider>(
      builder: (ctx, obj, child) => ListView.builder(
        itemBuilder: (ctx, i) => Container(
          margin: EdgeInsets.all(8),
          child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset("assets/marker.png",fit: BoxFit.cover,),
              ),
              title: Text("${obj.getItemsList[i].title}"),
              subtitle: Text("${obj.getItemsList[i].address}"),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () async {
                  //-------------------
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Are you sure!"),
                      content: Text("Do you want to remove the item?"),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("No")),
                        FlatButton(
                            onPressed: () async {
                              Navigator.of(ctx).pop();
                              try {
                                await Provider.of<LocationProvider>(context,
                                        listen: false)
                                    .deleteItem(obj.getItemsList[i].id);
                              } catch (e) {
                                scaffold.hideCurrentSnackBar();
                                scaffold.showSnackBar(SnackBar(
                                  content: Text("Deleting Failed"),
                                ));
                              }
                            },
                            child: Text("Yes"))
                      ],
                    ),
                  );
                  //------------------
                },
              )),
        ),
        itemCount: obj.getItemsList.length,
      ),
    );
  }
}
