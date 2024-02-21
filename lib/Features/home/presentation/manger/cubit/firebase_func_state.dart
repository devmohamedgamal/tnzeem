part of 'firebase_func_cubit.dart';

@immutable
sealed class FirebaseFuncState {}

final class FirebaseFuncInitial extends FirebaseFuncState {}

final class FirebaseFuncLoading extends FirebaseFuncState {}

final class FirebaseFuncFailure extends FirebaseFuncState {
  final String errMessage;

  FirebaseFuncFailure({required this.errMessage});
}

final class FirebaseFuncSuccess extends FirebaseFuncState {
  final DateTime startDate;

  FirebaseFuncSuccess({required this.startDate});
}
