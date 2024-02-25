// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tnzeem/Features/home/data/repos/firebase_func_repo_impl.dart';

part 'firebase_func_state.dart';

class FirebaseFuncCubit extends Cubit<FirebaseFuncState> {
  FirebaseFuncCubit(this.firebaseFuncRepoImpl) : super(FirebaseFuncInitial());
  final FirebaseFuncRepoImpl firebaseFuncRepoImpl;

  Future<void> getDate({required String uid}) async {
    emit(FirebaseFuncLoading());
    var result = await firebaseFuncRepoImpl.getStartDate(uid: uid);
    result.fold((failure) {
      emit(FirebaseFuncFailure(errMessage: failure));
    }, (success) {
      emit(FirebaseFuncSuccess(startDate: success));
    });
  }

  Future<void> getWorkDate({required String uid}) async {
    emit(GetWorkDateLoading());
    var result = await firebaseFuncRepoImpl.getAllWorkDate(uid: uid);
    result.fold((failure) {
      emit(GetWorkDateFailure(errMessage: failure));
    }, (success) {
      emit(GetWorkDateSuccess(allWorkDate: success));
    });
  }
}
