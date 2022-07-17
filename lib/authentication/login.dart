import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/authentication/auth_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/mainScreens/home_screen.dart';
import 'package:sellers_app/widgets/loading_dialog.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      //login
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Please input correct email/password!",
            );
          });
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingDialog(message: "Signing you in. Please wait...");
        });

    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      readDataAndSetSataLocally(currentUser!);
    }
  }

  Future readDataAndSetSataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("merchants")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if(snapshot.exists){
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!.setString(
            "email", snapshot.data()!["sellerEmail"]);
        await sharedPreferences!.setString(
            "name", snapshot.data()!["sellerName"]);
        await sharedPreferences!.setString(
            "photoUrl", snapshot.data()!["sellerAvatarUrl"]);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }else{
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => const AuthScreen()));
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                message: "No record found",
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                "assets/images/seller.png",
                height: 150,
              ),
            ),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    isObscure: true,
                  ),
                ],
              )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(32))),
            height: 60,
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                ),
                onPressed: () {
                  formValidation();
                },
                child: const Text(
                  "Log In",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
          )
        ],
      ),
    );
  }
}
