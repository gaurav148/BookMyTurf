import 'dart:async';
import 'package:flutter/material.dart';
import 'OwnerHomePage.dart';
import 'UserHomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

String turfName;
String turfAddress;
String startTime;
String endTime;
int hours;
String turfOwner;
String contactNo;
String pricePerHour;

class AddTurf extends StatefulWidget {
  final FirebaseUser currentUser;
  AddTurf({
    @required this.currentUser
  });
  @override
  _AddTurfState createState() => _AddTurfState(currentUser: currentUser);
}

class _AddTurfState extends State<AddTurf> {
  final FirebaseUser currentUser;
  _AddTurfState({
    @required this.currentUser
  });
  final _formKey = new GlobalKey<FormState>();
  SharedPreferences preferences;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        fillColor: Color(0xffdbdbdb),
        filled: true, //set true to fill color
      )),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "BookMyTurf",
            style: TextStyle(color: Colors.white, fontSize: 25.0),
          ),
          centerTitle: true,
          backgroundColor: Colors.green[700],
        ),
        body: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(20.0, 00.0, 20.0, 0.0),
                child: SingleChildScrollView(
                  // new line
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name of Turf",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onSaved: (value) {
                          turfName = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Address of Turf",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onSaved: (value) {
                          turfAddress = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BasicTimeField(timeType: "Start time"),
                      SizedBox(
                        height: 20,
                      ),
                      BasicTimeField(timeType: "End time"),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Price (per hour)",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onSaved: (value) {
                          pricePerHour = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Contact No.",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onSaved: (value) {
                          contactNo = value;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RaisedButton(
                        onPressed: () {
                          _formKey.currentState.save();
                          addTurf();
                          
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
                          child: Text('     Add     ',
                              style: GoogleFonts.lato(fontSize: 20)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Future<Null> addTurf() async{
    preferences = await SharedPreferences.getInstance();
    hours = int.parse(endTime.substring(0,2)) - int.parse(startTime.substring(0,2));
    var turfTimings = new Map();
    for(int i=1;i<=hours;i++){
      turfTimings[(int.parse(startTime.substring(0,2)) + i).toString()] = false;
    }
    Firestore.instance
            .collection("turfs")
            .document(DateTime.now().millisecondsSinceEpoch.toString())
            .setData({
          "Name": turfName,
          "Address": turfAddress,
          "owner": currentUser.displayName,
          "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
          "Start Time": startTime,
          "End Time": endTime,
          "Price per hour": pricePerHour,
          "Hours per day": hours,
          "Contact No": contactNo,
          "Booking": turfTimings
        });

      Fluttertoast.showToast(msg: "Turf added successfully.");
  }

}

class BasicTimeField extends StatelessWidget {
  String timeType;
  BasicTimeField({Key key, this.timeType}) : super(key: key);

  final format = DateFormat("HH:mm");
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              timeType,
              style:
                  GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            DateTimeField(
              onSaved: (value) {
                if(timeType == "Start time")
                 startTime = value.toString().substring(11, 16);
                else
                  endTime = value.toString().substring(11,16);
              },
              format: format,
              onShowPicker: (context, currentValue) async {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.convert(time);
              },
            ),
          ]),
    );
  }
}

