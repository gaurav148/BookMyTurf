import 'dart:async';
import 'package:book_my_turf/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'turfDetails.dart';
const Color dg = const Color(0xFF0a3929);

class UserScreen extends StatefulWidget {

  final FirebaseUser currentUser;
  UserScreen({Key key, @required this.currentUser}) : super(key: key);

  @override
  UserScreenState createState() => UserScreenState(currentUser: currentUser);
}



class UserScreenState extends State<UserScreen>{
final FirebaseUser currentUser;
UserScreenState({
@required this.currentUser
});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(
            "BookMyTurf",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        actions: <Widget>[
          IconButton(onPressed: logoutUser, icon: Icon(Icons.close))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
//        backgroundColor: Colors.green[700],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Search")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
          ),
        ],
        selectedItemColor: Colors.green[700],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
              child: Padding(
                child: Text(
                  "Last Played",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.green[700],
                  ),
                ),
                padding: EdgeInsets.only(top: 35.0, left: 10)
              )

          ),
            Flexible(
              flex: 5,
              child: Container(
                child: StreamBuilder(
                  stream: Firestore.instance.collection("turfs").snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return Text("No turfs added");
                    }else{
                      return ListView.builder(
                        itemBuilder: (context,index)=> createItem(index, snapshot.data.documents[index]),
                        itemCount: snapshot.data.documents.length,
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        );
                    }
                  },
                )
              ),
            ),

          Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Padding(
                  child: Text(
                    "Nearby Turfs",
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.green[700],
                    ),
                  ),
                  padding: EdgeInsets.only(top: 35.0, left: 10)
              )

          ),
            Flexible(
              flex: 5,
              child: Container(
                child: StreamBuilder(
                  stream: Firestore.instance.collection("turfs").snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return Text("No turfs added");
                    }else{
                      return ListView.builder(
                        itemBuilder: (context,index)=> createItem(index, snapshot.data.documents[index]),
                        itemCount: snapshot.data.documents.length,
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        );
                    }
                  },
                )
              ),
            ),
          Flexible(
            flex: 1,
            child: Container(),
          )
        ],
      )
    );
    throw UnimplementedError();
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Null> logoutUser() async{
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();


    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
  }


  Widget createItem(int index, DocumentSnapshot document){
    return Column(
          children: <Widget>[
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Container(
                width: 350.0,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/loginPic.jpg"),
                        fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                width: 350.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0))
                ),
                child: FlatButton(
                  child: Text(
                    document["Name"],
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
//                              textAlign: TextAlign.center,
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> TurfDetails(currentUser: currentUser, document: document, userType: "User",)));
                  },
                ),
//                            padding: EdgeInsets.only(left: 10.0, top:7.0),
              ),
            )
          ],
        );
  }
}