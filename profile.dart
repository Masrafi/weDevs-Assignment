import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/main.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/editProfile.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/login.dart';
import 'package:fluttershare/widgets/header.dart';
import 'create_account.dart';

class Profile extends StatefulWidget {
  User currentUser;
  Profile({this.currentUser});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  getDriversList() async {
    return await Firestore.instance.collection('info').getDocuments();
  }
  QuerySnapshot querySnapshot;
  @override
  void initState() {
    super.initState();
    getDriversList().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
  }
  Widget _showDrivers(){
    if(querySnapshot != null){
      return ListView.builder(
        primary: false,
        itemCount: querySnapshot.documents.length,
        padding: EdgeInsets.all(12.0),
        itemBuilder: (context, i){
          return
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 60.0,
                        //child: Icon(CupertinoIcons.person,size: 65.0,),
                        backgroundImage: NetworkImage(currentUser.photoUrl),
                      ),
                    ),

                  ],
                ),
                Divider(thickness: 0.0,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${querySnapshot.documents[i].data['FirstName']}',style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),),
                    VerticalDivider(width: 5.0,),
                    Text('${querySnapshot.documents[i].data['LastName']}',style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),)
                  ],
                ),
                RaisedButton(
                  child: Text('Edit'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
                  },
                )
              ],
            );
        },
      );
    }
    else{
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            popupMenueButton(),
          ],
          title: Center(
            child:
            Center(
              child: Text(
                'Profile',
                style: TextStyle(
                    fontFamily: 'Signatra',
                    fontSize: 50.0
                ),

              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          child: _showDrivers(),
          onRefresh: (){
            _showDrivers();
          },
        )
    );
  }
  Widget popupMenueButton(){

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, size: 28.0,),
      itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[

        PopupMenuItem<String>(
          value: '',
          child: InkWell(
            child: Center(
              child: Text('Sign Out',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                ),
              ),
            ),
            onTap: logout,
          ),
        ),
      ],
    );
  }
  logout(){
    googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
  }
}
