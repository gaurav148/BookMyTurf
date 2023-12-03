import 'package:book_my_turf/Pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Register extends StatelessWidget {
  final String userType;
  Register({
    @required this.userType,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 20,right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                title(),
                SizedBox(height: 10,),
                entryField("Name"),
                entryField("Email id"),
                entryField("Phone number"),
                entryField("Password", isPassword: true),
                SizedBox(height: 10,),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage(userType: userType)));
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
                    child:
                    Text('     Register now     ', style: GoogleFonts.lato(fontSize: 20)),
                  ),
                ),
                SizedBox(height: 20,),
                FlatButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage(userType: userType)));
                  },
                  child:RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Already have an account ? ',
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(color: Color(0xFF64dd17),fontWeight: FontWeight.bold),
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
              obscureText: isPassword,  //to hide while entering the password
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xffdbdbdb),
                  filled: true,   //set true to fill color
                  )
                  )
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