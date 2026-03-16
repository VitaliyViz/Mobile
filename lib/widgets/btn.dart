import 'package:flutter/material.dart';
class AppBtn extends StatelessWidget{
  final String t;
  final VoidCallback o;
  const AppBtn(this.t,this.o,{super.key});
  @override Widget build(BuildContext context)=>
  ElevatedButton(
    onPressed:o,
    child:Text(t)
  );
}
