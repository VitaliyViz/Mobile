import 'package:flutter/material.dart';
class AppInp extends StatelessWidget{
  final String l;
  const AppInp(this.l,{super.key});
  @override Widget build(BuildContext context)=>TextField(
    decoration:InputDecoration(
      labelText:l,
      border:const OutlineInputBorder()
    )
  );
}
