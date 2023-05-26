import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:untitled/helper/utils.dart';

import '../admin/api/product_api/user_api.dart';
import '../helper/const.dart';
import '../models/user_model.dart';

class MapScreen extends StatefulWidget {
  final String address, area, name;
  const MapScreen(
      {super.key,
      required this.address,
      required this.area,
      required this.name});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  double? lat, long;
  bool isLoading = false;

  setLocation() {
    setState(() {
      isLoading = true;
    });
    _determinePosition().then((value) {
      lat = value.latitude;
      long = value.longitude;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    setLocation();
    super.initState();
  }

  saveUserDetails(String lat, String long) {
    setState(() {
      isLoading = true;
    });
    // here, we have to append our new address to the exisitng list of addresses
    AddressModel addressModel = AddressModel(
        address: widget.address,
        area: widget.area,
        latitude: lat,
        longitude: long);
    List<AddressModel> addresses = currentUser!.address;
    addresses.add(addressModel);
    UserModel userModel = UserModel(
      id: currentUser!.id,
      name: widget.name,
      phoneNum: currentUser!.phoneNum,
      address: addresses,
      favProduct: [],
      role: currentUser!.role,
    );
    UserApi().updateUser(userModel).then((value) {
      setState(() {
        isLoading = false;
      });
      getSnackBar('Address added successfully', context);
      currentUser = userModel;
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      // great, now lets move further to allow user to select one of the address before placing order
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      getSnackBar(error.toString(), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // we will use a package for map
      // now we want picker to be at our current location, so for that we will use another package
      body: isLoading
          ? getLoading()
          : OpenStreetMapSearchAndPick(
              center: LatLong(lat!, long!),
              buttonColor: Colors.blue,
              buttonText: 'Set Current Location',
              onPicked: (pickedData) {
                saveUserDetails(pickedData.latLong.latitude.toString(),
                    pickedData.latLong.longitude.toString());
                // print(pickedData.latLong.latitude);
                // print(pickedData.latLong.longitude);
                // print(pickedData.address);
              }),
    );
  }
}
