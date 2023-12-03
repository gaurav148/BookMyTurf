import 'package:book_my_turf/Pages/Bookings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TurfDetails extends StatelessWidget {
  final String userType;
  final FirebaseUser currentUser;
  final DocumentSnapshot document;
  TurfDetails({@required this.currentUser, @required this.document, @required this.userType});
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
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "About this turf",
                style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 27
                ),
              ),
            )
          ),
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: Container(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for(int i=0;i<3;i++)
                    Container(
                      margin: EdgeInsets.only(left: 15.0),
                      width: 370.0,
//                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/loginPic.jpg"),
                              fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),
                    )

                ],
              ),
            ),
          ),
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Name: " + document["Name"],
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Address: " + document["Address"],
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Timings: " + document["Start Time"] +" - " + document["End Time"],
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Owner: " + document["owner"],
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Price/Hour:  Rs. " + document["Price per hour"],
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Contact No: " + document["Contact No"],
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: userType == "User" ? FlatButton(
                    child: Text(
                        "Book Now",
                      style: GoogleFonts.portLligatSans(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.green[700],
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> BookingPage(document: document)));

                    },
                  ) 
                  : Container(),
                ),
              )
            ),
          )
        ],
      )
    );
  }
}


