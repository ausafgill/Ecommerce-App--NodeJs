part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

abstract class AuthActionState extends AuthState {}

final class AuthInitial extends AuthState {}

class AuthErrorState extends AuthActionState {
  final String err;
  AuthErrorState({
    required this.err,
  });
}

class AuthSuccessState extends AuthActionState {
  // final UserModel user;
  // AuthSuccessState({
  //   required this.user,
  // });
}

class UserloadingState extends AuthActionState {}

class UserSuccessState extends AuthActionState {
  final UserModel userModel;
  UserSuccessState({
    required this.userModel,
  });
}

class UserErrorState extends AuthActionState {}
