import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:fluttershare/widgets/header.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  //String _firstName;
  var _royFromController = new TextEditingController();
  var _royToController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  getDriversList() async {
    return await Firestore.instance.collection('info').getDocuments();
  }


  QuerySnapshot querySnapshot;

  @override
  void initState() {
    super.initState();
    getDriversList().then((results) {
      setState(() {
        //String _value;
        querySnapshot = results;
        //verifyID();
      });
    });
  }
  String result, fieldResult,fileResult1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,titleText: 'Login'),
      body: _showDrivers(),
    );
  }
  verifyID(){
    print('test');
    fieldResult = _royFromController.text;
    fileResult1=_royToController.text;
    getDriversList().then((results){
      setState(() {
        querySnapshot = results;
        final _value = querySnapshot.documents[0].data['FirstName'];
        final _value1 = querySnapshot.documents[0].data['Password'];
        if(_value == fieldResult && _value1 == fileResult1){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
        }else
          return result = "You Are Wrong";
      });
    });
  }

  Widget _showDrivers() {
    if (querySnapshot != null) {
      return ListView.builder(
        primary: false,
        itemCount: querySnapshot.documents.length,
        padding: EdgeInsets.all(12.0),
        itemBuilder: (context, i) {
          return Column(
            children: <Widget>[
              TextFormField(
                autovalidate: true,
                keyboardType: TextInputType.text,
                controller: _royFromController,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Text Field is Empty';
                  } else {}
                },
                decoration: InputDecoration(
                  // icon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                    // icon: Icon(Icons.location_on),
                    hintText: 'First Name',
                    labelStyle: TextStyle(
                      fontSize: 20.0,
                    )),
              ),
              Divider(),
              TextFormField(
                autovalidate: true,
                keyboardType: TextInputType.text,
                controller: _royToController,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Text Field is Empty';
                  } else {}
                },
                decoration: InputDecoration(
                  // icon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    // icon: Icon(Icons.location_on),
                    hintText: 'Password',
                    labelStyle: TextStyle(
                      fontSize: 20.0,
                    )),
              ),
              RaisedButton(
                child: Text('LogIN'),
                onPressed: verifyID,
              ),
              Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[ Text(' $result')],
              ),

            ],
          );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
