import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCategoryPackage extends StatefulWidget{
  MyCategoryPackage({Key key,this.title}):super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() =>_MyCategoryPackage();
}

class _MyCategoryPackage extends State<MyCategoryPackage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text(widget.title),
    ),
    body: Center(child: Text('StartPage'),),);
  }
}