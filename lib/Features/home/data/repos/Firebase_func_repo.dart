import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class FirebaseFuncRepo {
  Future<Either<String, DateTime>> getStartDate({required String uid});
  Future<Either<String, Map<String,dynamic>>> getAllWorkDate({required String uid});
}
