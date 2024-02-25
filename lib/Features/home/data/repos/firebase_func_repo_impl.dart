import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tnzeem/Features/home/data/repos/Firebase_func_repo.dart';

class FirebaseFuncRepoImpl implements FirebaseFuncRepo {
  @override
  Future<Either<String, DateTime>> getStartDate({required String uid}) async {
    String date =
        '${DateTime.now().year}:${DateTime.now().month}:${DateTime.now().day}';
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Timer').doc(uid).get();
      return right(userDoc[date]['startIn'].toDate());
    } on FirebaseException catch (e) {
      log(e.message!);
      return left(e.message!);
    } catch (e) {
      log(e.toString());
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getAllWorkDate(
      {required String uid}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('Timer').doc(uid).get();
      log(userDoc.data().toString());
      return right(userDoc.data() ?? {});
    } on FirebaseException catch (e) {
      log(e.message!);
      return left(e.message!);
    } catch (e) {
      log(e.toString());
      return left(e.toString());
    }
  }
}
