import 'package:flutter/material.dart';
import 'package:workos_arabic/core/constant/size_config.dart';

class HorizintalSpace extends StatelessWidget {
   HorizintalSpace(this.value);
final double? value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.defaultSize! * value!,
    );
  }
}

class VirtecalSpace extends StatelessWidget {
   VirtecalSpace(this.value);
final double? value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.defaultSize! * value!,
    );
  }
}