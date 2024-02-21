import 'package:dartz/dartz.dart';

abstract class FirebaseFuncRepo {
  Future<Either<String, DateTime>> getStartDate({required String uid});
  // Future<Either<String, String>> addEndDate({required String uid,required DateTime date});

}
