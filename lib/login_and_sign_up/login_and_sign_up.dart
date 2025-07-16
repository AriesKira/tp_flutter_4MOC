import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_flutter/core/bloc/userBloc/user_event.dart';

import '../commonWidgets/RegistrationTextFields.dart';
import '../core/bloc/userBloc/user_bloc.dart';
import '../core/bloc/userBloc/user_state.dart';
import '../core/enums/AuthStatus.dart';

class LoginAndSignUp extends StatefulWidget {
  const LoginAndSignUp({super.key});

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginAndSignUp()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  State<LoginAndSignUp> createState() => _LoginAndSignUpState();
}

class _LoginAndSignUpState extends State<LoginAndSignUp> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _mailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _mailController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    _mailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final newState = _mailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _passwordController.text.length >= 6;
    if (newState != _isActive) {
      setState(() {
        _isActive = newState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.error && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.toString())),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RegistrationTextFields(
                  controller: _mailController,
                  label: "Mail",
                  isPassword: false,
                ),
                const SizedBox(height: 12),
                RegistrationTextFields(
                  controller: _passwordController,
                  label: "Password",
                  isPassword: true,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            final loading = state.authStatus == AuthStatus.loading;
            return Padding(
              padding: const EdgeInsets.all(60),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: _isActive
                      ? WidgetStateProperty.all<Color>(const Color(0xFF00816a))
                      : WidgetStateProperty.all<Color>(const Color(0xFFEBEBE4)),
                ),
                onPressed: _isActive
                    ? () => _signUpWithMailAndPassword(context)
                    : null,
                child: loading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text("Continuer"),
              ),
            );
          },
        ),
      ),
    );
  }
  void _signUpWithMailAndPassword(BuildContext context) {
    final String mail = _mailController.text;
    final String password = _passwordController.text;
    context.read<UserBloc>().add(SignUpWithEmailAndPassword(mail, password));
  }
}
