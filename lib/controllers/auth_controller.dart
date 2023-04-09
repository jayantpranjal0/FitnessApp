import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:gfg_project/routes/routes.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController{

  Rx<bool> isLoading = false.obs;

  // making authcontroller globally accessible
  static AuthController instance = Get.find();

  late Rx<User?> _user;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user){
    if(user == null){
      Get.offAllNamed(RoutesClass.getLoginScreen());
    }else{
      Get.offAllNamed(RoutesClass.getHomeRoute());
    }

  }

  register(String email, String password, String userName) async{
    try{
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    }catch(e){
      Get.snackbar(
        "About User",
        "User Message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text("Account creation failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  signIn(String email,String password) async{
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }catch (e){
      Get.snackbar(
        "About Login",
        "Login Message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text("Login failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  signOut() async{
    await auth.signOut();
    await GoogleSignIn().signOut();
  }

  googleSignIn() async{

    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    try{
      auth.signInWithCredential(credential);
    }catch (e){
      Get.snackbar(
        "About Google Authentication",
        "Error in google signIn",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text("Account failed to login with google",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

  }

  facebookSignIn() async{
    try{
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
      final credential = FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
      await auth.signInWithCredential(credential);
    }catch (e){
      Get.snackbar(
        "About Facebook Authentication",
        "Error in facebook signIn",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text("Account failed to login with facebook",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

  }

}