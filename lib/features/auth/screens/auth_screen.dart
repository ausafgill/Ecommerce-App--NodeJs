import 'package:amazon/app.dart';
import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/features/auth/bloc/auth_bloc.dart';
import 'package:amazon/features/home/screens/home.dart';
import 'package:amazon/shared/widgets/bottomnav.dart';
import 'package:amazon/shared/widgets/helper_button.dart';
import 'package:amazon/shared/widgets/helper_textfield.dart';
import 'package:amazon/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _signUpKey = GlobalKey<FormState>();
  final _signInKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  Auth _auth = Auth.signup;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passController.dispose();
  }

  AuthBloc authBlocc = AuthBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: authBlocc,
        listenWhen: (previous, current) => current is AuthActionState,
        buildWhen: (previous, current) => current is! AuthActionState,
        listener: (context, state) {
          // TODO: implement listener
          if (state is AuthSuccessState) {
            showSnackbar(context: context, content: "SUCCESS");

            Navigator.pushNamedAndRemoveUntil(
              context,
              Decider.routeName,
              (route) => false,
            );
          }
          if (state is AuthErrorState) {
            final err = state;
            showSnackbar(context: context, content: state.err);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Welcome",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                  ),
                ),
                ListTile(
                  tileColor: _auth == Auth.signup
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundCOlor,
                  title: Text(
                    'Create Account',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  leading: Radio(
                      value: Auth.signup,
                      groupValue: _auth,
                      onChanged: (val) {
                        setState(() {
                          _auth = val!;
                        });
                      }),
                ),
                if (_auth == Auth.signup)
                  Form(
                      key: _signUpKey,
                      child: Container(
                        color: GlobalVariables.backgroundColor,
                        child: Column(
                          children: [
                            HelperTextField(
                              htxt: 'Name',
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Name';
                                }
                                return null;
                              },
                            ),
                            HelperTextField(
                              htxt: 'Email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Email';
                                }
                                return null;
                              },
                            ),
                            HelperTextField(
                              htxt: 'Password',
                              controller: _passController,
                              obscure: true,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Password';
                                }
                                return null;
                              },
                            ),
                            HelperButton(
                                name: 'Sign Up',
                                onTap: () {
                                  if (_signUpKey.currentState!.validate()) {
                                    authBlocc.add(AuthenticationEvent(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        password: _passController.text,
                                        type: AuthType.signup,
                                        context: context));
                                  }
                                })
                          ],
                        ),
                      )),
                ListTile(
                  tileColor: _auth == Auth.signin
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundCOlor,
                  title: Text(
                    'Sign In.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  leading: Radio(
                      value: Auth.signin,
                      groupValue: _auth,
                      onChanged: (val) {
                        setState(() {
                          _auth = val!;
                        });
                      }),
                ),
                if (_auth == Auth.signin)
                  Form(
                      key: _signInKey,
                      child: Container(
                        color: GlobalVariables.backgroundColor,
                        child: Column(
                          children: [
                            HelperTextField(
                              htxt: 'Email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Email';
                                }
                                return null;
                              },
                            ),
                            HelperTextField(
                              htxt: 'Password',
                              controller: _passController,
                              obscure: true,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Password';
                                }
                                return null;
                              },
                            ),
                            HelperButton(
                                name: 'Sign In',
                                onTap: () {
                                  if (_signInKey.currentState!.validate()) {
                                    authBlocc.add(AuthenticationEvent(
                                        email: _emailController.text,
                                        password: _passController.text,
                                        type: AuthType.signin,
                                        context: context));
                                  }
                                })
                          ],
                        ),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}
