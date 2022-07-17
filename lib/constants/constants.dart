import 'package:flutter/material.dart';
class ConstantColors {
  final Color lightColor = const Color(0xff6c788a);
  final Color darkColor = const Color(0xFF100E20);
  final Color blueColor = const Color(0xFFF9301B);
  final Color lightBlueColor = const Color(0xFFF9301B).withOpacity(0.5);
  final Color redColor = Colors.red;
  final Color whiteColor = Colors.white;
  final Color blueGreyColor = Colors.blueGrey.shade900;
  final Color greenColor = Colors.greenAccent;
  final Color yellowColor = Colors.yellow;
  final Color transparent = Colors.transparent;
  final Color greyColor = Colors.grey.shade600;
}

const kDefaultPadding = 16.0;
const kPrimaryColor = Color(0xFFF9301B);
const textColor = Color(0xFFFFFFFF);
const kBackgroundColor = Color(0xFFDFDFDF);
const kSecondaryColor = Color(0xff050352);
const kSearchBackgroundColor = Color(0xffF2F2F2);
const kAnimationDuration = Duration(milliseconds: 200);

OutlineInputBorder textFieldBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: kPrimaryColor.withOpacity(0.2),
  ),
);

const kTextFieldDecoration = InputDecoration(
  fillColor: Color(0xFFFAFAFA),
  filled: true,
  hintText: 'Enter Amount',
  hintStyle: TextStyle(color: Colors.blueGrey),
  contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(25.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFAFAFA), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(25.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFAFAFA), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(25.0)),
  ),
);

const kDivider = Padding(
  padding: EdgeInsets.symmetric(horizontal: 150.0),
  child: Divider(
    thickness: 4,
    color: Colors.grey,
  ),
);

 final kButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(6),
);

 const kSheetShape = RoundedRectangleBorder(
   borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),),
 );
