import 'dart:async';
import 'dart:developer';

import 'package:amazon/app.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/auth/model/user_model.dart';
import 'package:amazon/features/auth/repo/auth_repo.dart';
import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

enum AuthType { signup, signin }

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthenticationEvent>(authenticationEvent);
  }

  FutureOr<void> authenticationEvent(
      AuthenticationEvent event, Emitter<AuthState> emit) async {
    switch (event.type) {
      case AuthType.signup:
        try {
          bool success = await AuthRepo.signupUser(UserModel(
            id: '',
            name: event.name,
            email: event.email,
            password: event.password,
            address: '',
            type: 'user',
            token: '',
            cart: [],
          ));
          if (success) {
            emit(AuthSuccessState());
          } else {
            emit(AuthErrorState(err: 'Something went Wrong!'));
          }
        } catch (e) {
          emit(AuthErrorState(err: e.toString()));
        }
      case AuthType.signin:
        try {
          String status = await AuthRepo.signinUser(
              event.email, event.password, event.context);
          //log(userModel!.email.toString());
          log("BLOC:$status");
          if (status == 'Success') {
            emit(AuthSuccessState());
          } else {
            emit(AuthErrorState(err: status.toString()));
          }
        } catch (e) {
          emit(AuthErrorState(err: e.toString()));
        }

        break;
    }
  }
}
