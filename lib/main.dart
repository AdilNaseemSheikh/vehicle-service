import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_service_provider/provider/auth.dart';
import 'package:vehicle_service_provider/provider/location_provider.dart';
import 'package:vehicle_service_provider/screens/home_screen.dart';
import 'package:vehicle_service_provider/screens/input_screen.dart';
import 'package:vehicle_service_provider/screens/mechanic_auth.dart';
import 'package:vehicle_service_provider/screens/user_auth.dart';
import 'package:vehicle_service_provider/screens/my_locations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Future<bool> _onBackPressed(BuildContext ctx) {
  //   return showDialog(
  //       context: ctx,
  //       builder: (ctx) => AlertDialog(
  //             content: Text("Do you want to quit the application"),
  //             actions: [
  //               FlatButton(onPressed: ()=>Navigator.of(ctx).pop(false), child: Text("No")),
  //               FlatButton(onPressed: ()=>Navigator.of(ctx).pop(true), child: Text("Yes"))
  //             ],
  //           ));
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, LocationProvider>(
            create: null,
            update: (ctx, obj, previous) => LocationProvider(obj.userId,
                obj.token), //previous==null?[]: previous.getItemsList
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, obj, child) => MaterialApp(
            title: "Vehicle Service Provider",
            theme: ThemeData(
                primarySwatch: Colors.indigo,
                accentColor: Color.fromRGBO(255, 122, 123, 1)),
            home: obj.isAuth ? HomeScreen() : UserAuth(),
            routes: {
              MyLocations.routeName: (ctx) => MyLocations(),
              MechanicAuth.routeName: (ctx) => MechanicAuth(),
              UserAuth.routeName: (ctx) => UserAuth(),
              InputScreen.routeName: (ctx) => InputScreen(),
            },
          ),
        ),
    );
  }
}
