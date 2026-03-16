import 'package:flutter/material.dart';
class FanImg extends StatelessWidget{
  final double s;
  const FanImg(this.s,{super.key});
  @override Widget build(BuildContext context)=>
  Icon(
    Icons.cyclone,
    size:s,
    color:Colors.blueAccent
  );
}
