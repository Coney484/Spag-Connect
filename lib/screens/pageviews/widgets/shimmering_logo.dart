import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spag_connect/screens/universal_variables.dart';

class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Shimmer.fromColors(
        baseColor: UniversalVariables.blackColor,
        highlightColor: Colors.white,
        child: Image.asset("assets.images/app_logo.png"),
      )
    );
  }
}