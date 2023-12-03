import 'dart:async';
import 'package:book_my_turf/Pages/turfDetails.dart';
import 'package:book_my_turf/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddTurf.dart';
const Color dg = const Color(0xFF0a3929);

class OwnerScreen extends StatefulWidget {
  final FirebaseUser currentUser;
  final String userType;
  OwnerScreen({Key key, @required this.currentUser, @required this.userType}) : super(key: key);

  @override
  OwnerScreenState createState() => OwnerScreenState(currentUser: currentUser, userType: userType);
}



class OwnerScreenState extends State<OwnerScreen>{
final FirebaseUser currentUser;
final String userType;
OwnerScreenState({
  @required this.currentUser,
  @required this.userType
});
@override
  void initState() {
    super.initState();
  }
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
                title: Text("Profile")
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
                  "Add a turf",
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.green[700],
                  ),
                ),
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 25.0),
              ),

            ),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTurf(currentUser: currentUser)));
                    },
                    elevation: 10.0,
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                    child: Icon(MdiIcons.cricket, size: 65,),
                    padding: EdgeInsets.all(10),
                  ),RawMaterialButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTurf(currentUser: currentUser)));
                    },
                    elevation: 10.0,
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                    child: Icon(MdiIcons.soccer, size: 70,),
                    padding: EdgeInsets.all(10),
                  ),
                  RawMaterialButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTurf(currentUser: currentUser,)));
                    },
                    elevation: 10.0,
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                    child: Icon(MdiIcons.tennis, size: 70,),
                    padding: EdgeInsets.all(10),
                  )
                ],
              )
            ),
            Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Padding(
                    child: Text(
                      "Turf Logs",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.green[700],
                      ),
                    ),
                    padding: EdgeInsets.only(top: 30.0, left: 10)
                )

            ),
            Flexible(
              flex: 5,
              child: Container(
                child: StreamBuilder(
                  stream: Firestore.instance.collection("turfs").where("owner", isEqualTo: currentUser.displayName).snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return Text("No turfs added");
                    }else{
                      return ListView.builder(
                        itemBuilder: (context,index)=> createItem(index, snapshot.data.documents[index], 0),
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
                      "Other Turfs",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.green[700],
                      ),
                    ),
                    padding: EdgeInsets.only(top: 30.0, left: 10)
                )

            ),
             Flexible(
              flex: 5,
              child: Container(
                child: StreamBuilder(
                  stream: Firestore.instance.collection("turfs").where("owner", isGreaterThan: currentUser.displayName).snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return Text("No turfs added");
                    }else{
                      return ListView.builder(
                        itemBuilder: (context,index)=> createItem(index, snapshot.data.documents[index], 1),
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



  Widget createItem(int index, DocumentSnapshot document, int val){
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
                    if(val == 1){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> TurfDetails(currentUser: currentUser, document: document, userType: userType,)));

                    }
                  },
                ),
//                            padding: EdgeInsets.only(left: 10.0, top:7.0),
              ),
            )
          ],
        );
  }

}



