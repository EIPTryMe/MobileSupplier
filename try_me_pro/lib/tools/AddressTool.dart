import 'package:flutter/material.dart';

import 'package:geocoder/geocoder.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tryme/Globals.dart';

class AddressTool {
  static Future<Address> getAddressFromString(String str) async {
    bool error = false;
    List<Address> addresses =
        await Geocoder.local.findAddressesFromQuery(str).catchError((_) {
      error = true;
    });
    return (error == false ? addresses.first : null);
  }

  static Future<Address> getAddress(BuildContext context, String str) async {
    Address address = await AddressTool.getAddressFromString(str);

    LocationResult locationResult = await showLocationPicker(
      context,
      mapApiKey,
      automaticallyAnimateToCurrentLocation: address == null ? true : false,
      initialCenter: address == null
          ? LatLng(48.8589507, 2.2770205) // Paris
          : LatLng(address.coordinates.latitude, address.coordinates.longitude),
      myLocationButtonEnabled: true,
      desiredAccuracy: LocationAccuracy.best,
    );
    return (await AddressTool.getAddressFromString(locationResult.address));
  }
}
