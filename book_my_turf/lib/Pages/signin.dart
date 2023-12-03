import 'register.dart';
import 'OwnerHomePage.dart';
import 'UserHomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  final String userType;
  LoginPage({
    @required this.userType,
  });
  @override
  _LoginPageState createState() => _LoginPageState(userType: userType);
}

class _LoginPageState extends State<LoginPage> {
  final String userType;

  _LoginPageState({
    @required this.userType,
  });

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;

  bool isLoggedIn = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoggedIn = true;
    });

    preferences = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      if (userType == "User") {
        print(googleSignIn.currentUser);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserScreen(currentUser: currentUser,)));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OwnerScreen(currentUser: currentUser,userType: userType,)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                title(),
                SizedBox(
                  height: 10,
                ),
                entryField("Phone number"),
                entryField("Password", isPassword: true),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () {
                    if (userType == "Owner") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OwnerScreen(currentUser: currentUser,userType: userType,)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserScreen(currentUser: currentUser,)));
                    }
                  },
                  textColor: Colors.blueGrey[900],
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF76ff03),
                          Color(0xFF64dd17),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Text('     Login     ',
                        style: GoogleFonts.lato(fontSize: 20)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 2,
                    )),
                    Text(' or ', style: GoogleFonts.lato(fontSize: 20)),
                    Expanded(
                        child: Divider(
                      thickness: 2,
                    )),
                  ],
                ),
                SignInButton(
                  Buttons.GoogleDark,
                  onPressed: controlGoogleSignIn,
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Register(
                                  userType: userType,
                                )));
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Don't have an account ? ",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                                color: Color(0xFF64dd17),
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> controlGoogleSignIn() async {
    preferences = await SharedPreferences.getInstance();

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuthentication =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken);

    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      //SignIn Success

      //Check if already signed up
      final QuerySnapshot resultQuery = await Firestore.instance
          .collection("users")
          .where("id", isEqualTo: firebaseUser.uid)
          .getDocuments();

      final List<DocumentSnapshot> documentSnapshots = resultQuery.documents;
      //Save data to Firestore
      if (documentSnapshots.length == 0) {
        Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .setData({
          "Name": firebaseUser.displayName,
          "photoUrl": firebaseUser.photoUrl,
          "id": firebaseUser.uid,
          "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
          "type:": userType == "User" ? "User" : "Owner",
        });
        //Write data to local
        currentUser = firebaseUser;
        await preferences.setString("id", currentUser.uid);
        await preferences.setString("Name", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoUrl);
      } else {
        currentUser = firebaseUser;
        await preferences.setString("id", documentSnapshots[0]["id"]);
        await preferences.setString("Name", documentSnapshots[0]["Name"]);
        await preferences.setString(
            "photoUrl", documentSnapshots[0]["photoUrl"]);
      }
      Fluttertoast.showToast(msg: "Sign In Successful!");
      if (userType == "User") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserScreen(currentUser: currentUser)));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OwnerScreen(currentUser: currentUser, userType: userType,)));
      }
    } else {
      //SignIn failed
      Fluttertoast.showToast(msg: "Sign In failed! Try Again");
    }
  }
}

Widget entryField(String title, {bool isPassword = false}) {
  return Container(
    margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
            obscureText: isPassword, //to hide while entering the password
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xffdbdbdb),
              filled: true, //set true to fill color
            ))
      ],
    ),
  );
}

Widget title() {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
        text: 'Book My ',
        style: GoogleFonts.portLligatSans(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: 'Turf',
            style: TextStyle(color: Color(0xFF64dd17), fontSize: 40),
          ),
        ]),
  );
}
