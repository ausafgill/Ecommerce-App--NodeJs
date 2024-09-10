part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthenticationEvent extends AuthEvent {
  String name;
  final String email;
  final String password;
  final AuthType type;
  BuildContext context;
  AuthenticationEvent({
    this.name = '',
    required this.email,
    required this.password,
    required this.type,
    required this.context,
  });
}

class getUserDataEvent extends AuthEvent {}

class GetUserDataEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}
