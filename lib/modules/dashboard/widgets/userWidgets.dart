// import 'package:IITDAPP/ThemeModel.dart';
import 'package:IITDAPP/ThemeModel.dart';
import 'package:IITDAPP/values/Constants.dart';
// import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserEmail extends StatelessWidget {
  const UserEmail({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
      child: Text(
        // 'kadir.corekci@gmail.com',
        currentUser.email,
        // style: TextStyle(
        //     fontSize: 500,
        //     color: Provider.of<ThemeModel>(context).theme.PRIMARY_TEXT_COLOR),
        style: GoogleFonts.openSans(fontSize: 14),
      ),
    );
  }
}

class UserName extends StatelessWidget {
  const UserName({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      currentUser.name ?? 'Unnamed',
      // 'Kadir Corekci',
      style: GoogleFonts.openSans(fontSize: 30),
      // style: TextStyle(
      //     fontSize: 30,
      //     color: Provider.of<ThemeModel>(context).theme.PRIMARY_TEXT_COLOR),
    );
  }
}

class UserImage extends StatelessWidget {
  const UserImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load the avImage from the SettingsHandler

    // return Container(
    //   color: Colors.red,
    //   padding: EdgeInsets.all(40),
    //   child: CircleAvatar(
    //     backgroundImage: AssetImage(avImage),
    //     radius: MediaQuery.of(context).size.width / 5,
    //   ),
    // );

    bgimage ??= 'assets/images/cosmos.png';
    avImage ??= 'assets/images/origami2.png';
    //print(bgimage);
    return Stack(children: [
      Container(
        // height: 210,
        height: MediaQuery.of(context).size.height * 0.215,
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),

        // color: Colors.red,
        child: Image.asset(
          bgimage,
          //'assets/bg/1.jpg',
          //backgroundimages['beach'],

          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        // top: 142,
        top: MediaQuery.of(context).size.height * 0.173,
        left: MediaQuery.of(context).size.width / 2 - 65,
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: CircleAvatar(
            radius: 60,
            backgroundColor:
                Provider.of<ThemeModel>(context).theme.SCAFFOLD_BACKGROUND,
            backgroundImage: AssetImage(avImage),
            //AssetImage('assets/avatars/cat.jpg'),
          ),
        ),
      ),
    ]);
  }
}
