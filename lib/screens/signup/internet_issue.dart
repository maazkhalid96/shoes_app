import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

checkInternet(BuildContext context) async {
  var connectionResult = await Connectivity().checkConnectivity();
  if (connectionResult == ConnectivityResult.none) {
    //// No Internet Message
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("No Internet Connection! Please check your network."),
      ),
    );
    return false;
  }
  return true;
}
