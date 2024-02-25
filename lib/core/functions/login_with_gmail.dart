import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static CollectionReference<Map<String, dynamic>> userTimer =
      FirebaseFirestore.instance.collection('Timer');
  static User? get user => auth.currentUser;
  static String date =
      '${DateTime.now().year}:${DateTime.now().month}:${DateTime.now().day}';

  Future<dynamic> signInWithGoogle({required Function onSignIn}) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          try {
            CollectionReference users =
                FirebaseFirestore.instance.collection('users');
            await users.doc(user.uid).set({
              'name': user.displayName,
              'uid': user.uid,
              'email': user.email,
              'photoUrl': user.photoURL,
            });
            await userTimer.doc(user.uid).set({
              '${DateTime.now().year}:${DateTime.now().month}:${DateTime.now().day}':
                  {
                'startIn': DateTime.now(),
                'workHours': {},
              },
            });
          } catch (e) {
            log('catch error: $e');
          }
        } else {
          DocumentReference<Map<String, dynamic>> documentReference =
              userTimer.doc(user.uid);
          // Get the document snapshot
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
              await documentReference.get();
          // Convert the JsonDocumentSnapshot to a Map
          Map<String, dynamic> userDoc = documentSnapshot.data() ?? {};

          if (userDoc.containsKey(date)) {
            await userTimer.doc(user.uid).update({
              '${DateTime.now().year}:${DateTime.now().month}:${DateTime.now().day}':
                  {
                'startIn': DateTime.now(),
                'workHours': userDoc[date]['workHours'],
              },
            });
          } else {
            await userTimer.doc(user.uid).update({
              '${DateTime.now().year}:${DateTime.now().month}:${DateTime.now().day}':
                  {
                'startIn': DateTime.now(),
                'workHours': {},
              },
            });
          }
        }
        onSignIn();
      }
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      log('exception-> $e');
    } catch (e) {
      log('exception-> $e');
    }
  }

  Future<bool> signOutFromGoogle(
      {required Function onSignIn, required DateTime startIn}) async {
    try {
      await whenSignOut(startIn: startIn);
      await FirebaseAuth.instance.signOut();
      log('message');
      onSignIn();
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<void> whenSignOut({required DateTime startIn}) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        userTimer.doc(user!.uid);
    // Get the document snapshot
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();
    // Convert the JsonDocumentSnapshot to a Map
    Map<String, dynamic> userDoc = documentSnapshot.data() ?? {};
    Duration difference = DateTime.now().difference(startIn);

    if (userDoc[date]['workHours']['h'] != null) {
      int hours = userDoc[date]['workHours']['h'] + difference.inHours;
      int minuts = userDoc[date]['workHours']['m'] + difference.inMinutes % 60;
      int seconds;
      if (userDoc[date]['workHours']['s'] + difference.inSeconds % 60 > 60) {
        minuts += 1;
        seconds =
            userDoc[date]['workHours']['s'] + difference.inSeconds % 60 - 60;
      } else {
        seconds = userDoc[date]['workHours']['s'] + difference.inSeconds % 60;
      }
      Map<String, dynamic> workHores = {
        'h': hours,
        'm': minuts,
        's': seconds,
      };
      await userTimer.doc(user!.uid).update({
        '${DateTime.now().year}:${DateTime.now().month}:${DateTime.now().day}':
            {
          'startIn': startIn,
          'endIn': DateTime.now(),
          'workHours': workHores,
        },
      });
    } else {
      await userTimer.doc(user!.uid).update({
        '${DateTime.now().year}:${DateTime.now().month}:${DateTime.now().day}':
            {
          'startIn': startIn,
          'endIn': DateTime.now(),
          'workHours': {
            "h": difference.inHours,
            "m": difference.inMinutes % 60,
            's': difference.inSeconds % 60,
          },
        },
      });
    }
  }
}
