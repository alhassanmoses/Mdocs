import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart' as geoloc;

import '../../models/location_data.dart';

import './location.dart';

class StaticMapsProvider extends StatefulWidget {
  final String googleMapsApiKey;
  final List locations;
  final Map currentLocation;
  // final String currentLocation;

  StaticMapsProvider(this.googleMapsApiKey, {this.locations});

  _StaticMapsProviderState createState() => _StaticMapsProviderState();
}

class _StaticMapsProviderState extends State<StaticMapsProvider> {
  Uri renderUrl;

  static const int defaultWidth = 600;
  static const int defaultHeight = 400;

  Map<String, String> defaultLocation = {
    "latitude": '37.0902',
    "longitude": '-95.7192'
  };

  _buildUrl(Map currentLocation, List locations) {
    Uri finalUri;

    Uri baseUri = Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {});

    var finalUrl = baseUri;

    if (currentLocation != null && widget.markers.length == 0) {
      finalUrl = baseUri.replace(queryParameters: {
        'center':
            '${currentLocation['latitude']},${currentLocation['longitude']}',
        'zoom': widget.zoom.toString(),
        'size': '${width ?? defaultWidth}x${height ?? defaultHeight}',
        '${widget.googleMapsApiKey}': ''
      });
    }

    setState(() {
      renderUrl = finalUrl.toString();
    });
  }

//findUserLocation
  Future<Null> getUserLocation() async {
    // final location = geoloc.Location();
    // final currentLocation = await location.getLocation();
    // final address =
    //     await _getAddress(currentLocation.latitude, currentLocation.longitude);

    // _getStaticMap(address,
    //     geocode: false,
    //     lat: currentLocation.latitude,
    //     lng: currentLocation.longitude);

    Map<String, double> location;
    try {
      location = await _location.getLocation;
      setState(() {
        deviceLocation = location;
      });
    } catch (exception) {
      print(exception);
    }
  }

  void resetMap() {
    setState(() {
      LocationData = null;
    });
  }

  @override
  _buildUrl();

  @override
  Widget build(BuildContext context) {
    var currentLocation = widget.currentLocation;
    if (widget.currentLocation == null) {
      currentLocation = defaultLocation;
    }
    _buildUrl(currentLocation, widget.markers);
  }
}
