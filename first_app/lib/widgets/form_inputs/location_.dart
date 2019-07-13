// import 'dart:async';
import 'package:flutter/material.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:scoped_model/scoped_model.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as geoloc;

// import '../../models/product.dart';
// import '../../models/location_data.dart';
import './static_maps_provider.dart';

// class LocationInput extends StatefulWidget {
//   final Function setLocation;
//   final Product product;
//   final LocationData location;

//   LocationInput(this.setLocation, this.product, {this.location});

//   _LocationInputState createState() => _LocationInputState();
// }

// class _LocationInputState extends State<LocationInput> {

//   final TextEditingController _addressInputController = TextEditingController();

//   GoogleMapController mapController;

//   String staticMapApiKey = 'AIzaSyBvqdQbakqnCO4fsu_aKn6O_kqU11upezA';

//   final CameraPosition productLocation = CameraPosition(target: LatLng(LocationData.latitude, locationData.longitude));
//   final String en = 'en';

//    searchAndNavigate() async{

//     List<Placemark> placemark = await Geolocator().placemarkFromAddress( _addressInputController.text, localeIdentifier: en);

//     mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//       target: LatLng(placemark[0].position.latitude, placemark[0].position.longitude))
//     ));

//     }

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         TextFormField(
//           focusNode: _addressInputFocusNode,
//           controller: _addressInputController,
//           validator: (String value) {
//             if (_locationData == null || value.isEmpty) {
//               return "No valid location found.";
//             }
//           },
//           decoration: InputDecoration(labelText: 'Enter Address', icon: Icon(Icons.search), suffixIcon: IconButton(
//             icon: Icon(Icons.search),
//             onPressed: searchAndNavigate,
//           )),

//         ),
//         SizedBox(
//           height: 10.0,
//         ),
//         FlatButton(
//           child: Text('Locate User'),
//           onPressed: _getUserLocation,
//         ),
//         SizedBox(
//           height: 10.0,
//         ),
//         _staticMapUri == null
//             ? Container()
//             : Image.network(_staticMapUri.toString())
//       ],
//     );

//   }
// }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class LocationInput extends StatefulWidget {
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  geoloc.Location _location = new geoloc.Location();
  dynamic deviceLocation;

  String googleMapsApiKey = 'AIzaSyCzxj6UFfx8uvDaaE9OSSPkjJXdou3jD9I';
  geoloc.Location _location = geoloc.Location();
  Map<String, double> _currentLocation;
  List locations = [];

  Future<Null> findUserLocation() async {
    Map<String, double> location;
    try {
      location = await _location.getLocation();
      setState(() {
        _currentLocation = {
          "latitude": location["latitude"],
          "longitude": location['longitude'],
        };
      });
    } catch (exception) {}
  }

  void resetMap() {
    setState(() {
      _currentLocation = null;
      locations = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          StaticMapsProvider(googleMapsApiKey, currentLocation: deviceLocation),
        ],
      ),
    );
  }
}
