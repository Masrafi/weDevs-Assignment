import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:uuid/uuid.dart';

class CreateAccount extends StatefulWidget {
  final User currentUser;
  CreateAccount({this.currentUser});
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {


  final _scaffold = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username;
  var lastName = new TextEditingController();
  var phone = new TextEditingController();
  var password = new TextEditingController();
  var email = new TextEditingController();
  String postID = Uuid().v4();
  bool isUploading = false;

  creatPost({String username, String lastname,String phone, String password, String email}){
   userInfo.document(postID).setData({
     'FirstName':username,
     'LastName':lastname,
     'Phone':phone,
     'Email':email,
     'Password':password
   });
  }

  submit()async{
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      SnackBar snackBar = SnackBar(content: Text('Welcome $username'),);
      _scaffold.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 2),(){
        Navigator.pop(context,username);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Home1()));
      });
      setState(() {
        isUploading = true;
      });

    }
    creatPost(
      username: username,
      lastname: lastName.text,
      phone: phone.text,
      password: password.text,
        email: email.text
    );
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffold,
      appBar: header(context,titleText: 'Registration'),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      'Create Your Registration',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (val){
                              if(val.trim().length < 3 || val.isEmpty){
                                return 'Username is Too Short';
                              }else if(val.trim().length > 12){
                                return 'Username is Too Long';
                              }else{
                                return null;
                              }
                            },
                            onSaved: (val)=> username = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'FirstName',
                              hintText: 'FirstName',
                              labelStyle: TextStyle(fontSize: 15.0),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (val){
                              if(val.trim().length < 3 || val.isEmpty){
                                return 'Username is Too Short';
                              }else if(val.trim().length > 12){
                                return 'Username is Too Long';
                              }else{
                                return null;
                              }
                            },
                            controller: lastName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'LastName',
                              hintText: 'LastName',
                              labelStyle: TextStyle(fontSize: 15.0),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (val){
                              if(val.trim().length < 3 || val.isEmpty){
                                return 'Username is Too Short';
                              }else{
                                return null;
                              }
                            },
                            controller: email,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              hintText: 'Email',
                              labelStyle: TextStyle(fontSize: 15.0),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Phone Number is Empty';
                              } else if(val.trim().length < 11) {
                                return 'You pree less then 11 numbers';
                              }else  if(val.trim().length>11){
                                return 'You press more 11 numbers';
                              }else{

                              }
                            },
                            controller: phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'PhoneNumber',
                              hintText: 'PhoneNumber',
                              labelStyle: TextStyle(fontSize: 15.0),
                            ),
                          ),
                          TextFormField(
                            validator: (val){
                              if(val.trim().length < 6 || val.isEmpty){
                                return 'Username is Too Short';
                              }else if(val.trim().length > 12){
                                return 'Username is Too Long';
                              }else{
                                return null;
                              }
                            },
                            controller: password,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              hintText: 'Password',
                              labelStyle: TextStyle(fontSize: 15.0),
                            ),
                          ),
                    ],
                   )

                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    submit();
                  },
                  child: Container(
                    height: 50.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.teal,
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
