import 'dart:math';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class CommonService {
  // Random AlphaNUmeric Generation
  String randomAlphaNum() {
    String randomString = '';

    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    randomString = String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
    return randomString;
  }

// Login Time
  String getLoginTime() {
    String loginTime = "";

    final time = DateFormat('hh:mm:ss a').format(DateTime.now());
    loginTime = DateFormat.jm().format(DateFormat("hh:mm:ss a").parse(time));
    return loginTime;
  }

// Login Date
  String getLoginDate() {
    String loginDate = "";

    loginDate = DateFormat('MMMM,dd,yyyy').format(DateTime.now());
    return loginDate;
  }

  // YesterDay Date
  String getYesterdayDate() {
    String yesterdayDate = "";

    yesterdayDate = DateFormat('MMMM,dd,yyyy')
        .format(DateTime.now().subtract(const Duration(days: 1)));
    return yesterdayDate;
  }

  /* Getting Lat and Lng from position */
  Future<Position> getLocation() async {
    Position? currentPosition;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    // Test if location services are enabled,accessing the position and request users of the
    // Permissions are denied, next time you could try requesting permissions again
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(content: Text( 'Location Permission Denied')),);
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return currentPosition;
  }

  /* Getting Address from position*/

  getAddressFromLatLong(Position position) async {
    String currentAddress = '';
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (kDebugMode) {
      print(placemarks);
    }
    Placemark place = placemarks[0];
    currentAddress = '${place.locality}';
    return currentAddress;
  }

  /* Getting IP address*/
  Future<String> getIpAddress() async {
    String ip;
    try {
      ip = await Ipify.ipv4();
    } on PlatformException {
      ip = 'Failed to get ipAddress.';
    }
    return ip;
  }
}
