import 'signin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Expanded(flex:3,child: Center( child: title()),),

                moveButtons(context,'Continue as Owner'),
                SizedBox(height: 20,),
                moveButtons(context,'Continue as User'),
                SizedBox(height: 40,),

              ],
            ),
            decoration: BoxDecoration(
              //color: Color(0xff7c94b6),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:[Colors.green[100], Colors.greenAccent[400]]),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.green.withOpacity(0.2), BlendMode.dstATop),
                image: AssetImage("images/back3.jpeg"),
              ),
            ),
          ),

        ),
      ),
    );
  }
}

  Widget title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Book My ',
          style: GoogleFonts.portLligatSans(
            fontSize: 60,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: 'Turf',
              style: TextStyle(color: Colors.white, fontSize: 60),
            ),
          ]),
    );
  }

  Widget moveButtons(BuildContext context,String title){
  String userType;
    return Container(
        margin: EdgeInsets.only(left: 20,right: 20),
        child: FlatButton(
          onPressed: (){
            if(title=='Continue as Owner')
              userType = "Owner";
            else
              userType = "User";

            Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage(userType: userType,)));
          },
          padding: EdgeInsets.all(10.0),
          child: Text(title, style:GoogleFonts.lato(fontSize: 20, color: Colors.white),),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
              style: BorderStyle.solid,
              width: 1,),
            borderRadius: BorderRadius.circular(30.0),
            ),   
          )
    );
  }

