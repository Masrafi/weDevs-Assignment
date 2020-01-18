import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/create_account.dart';
import 'package:fluttershare/pages/login.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

String postId = Uuid().v4();
final GoogleSignIn googleSignIn = GoogleSignIn();
final userRef = Firestore.instance.collection('users');
final userInfo = Firestore.instance.collection('info');
final DateTime timestamp = DateTime.now();
User currentUser;



class Home1 extends StatefulWidget {

  @override
  _Home1State createState() => _Home1State();
}

class _Home1State extends State<Home1> {



  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState(){
    super.initState();
    pageController = PageController();

    googleSignIn.onCurrentUserChanged.listen((account){
      handleSignIn(account);
    },onError: (err){
      print('Error User SignIn : $err');
    });

    googleSignIn.signInSilently(suppressErrors: false)
        .then((account){
      handleSignIn(account);
    }).catchError((err){
      print('Error User SignIn : $err');
    });
  }
  handleSignIn(GoogleSignInAccount account){
    if(account != null){
      createUserFirestore();
      setState(() {
        isAuth = true;
      });
    }else{
      setState(() {
        isAuth = false;
      });
    }
  }
  createUserFirestore() async{
    GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await userRef.document(user.id).get();
    if(!doc.exists){
      final username = await Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateAccount()));

      userRef.document(user.id).setData({
        'id':user.id,
        'email':user.email,
        'username':username,
        'displayName':user.displayName,
        'photoUrl':user.photoUrl,
        'timestamp':timestamp,
      });
      doc = await userRef.document(user.id).get();
    }
    currentUser = User.fromDocument(doc);
    print(currentUser);
    print(currentUser.displayName);

  }

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }



  login(){
    googleSignIn.signIn();
  }

  logout(){
    googleSignIn.signOut();
  }

  Scaffold buildAuthScreen(){
    return Scaffold(
      body: Login(),
    );
  }

  Scaffold buildUnAuthScreen(){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.yellowAccent,
              Colors.red,
              Colors.teal
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Masrafi',
              style: TextStyle(
                fontSize: 90.0,
                fontFamily: 'Signatra',
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/google_signin_button.png'),
                      fit: BoxFit.cover
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}


