import 'package:flutter/material.dart';
import 'package:health/auth/service/auth_service.dart';
import 'package:health/auth/service/user_service.dart';
import 'package:health/auth/widget/combined_screen.dart';



class LoginForm extends StatefulWidget {
  final UserService userService;
  final AuthService authService;

  const LoginForm({
    Key? key,
    required this.userService,
    required this.authService,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _responseMessage = '';
  bool _isLoading = false;
  bool _isSuccess = false;
  bool _obscurePassword = true;

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _responseMessage = '';
      _isSuccess = false;
    });

    try {
      final response = await widget.userService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      print(response);
      print(response.user);
      print(response.success);
      if (response.success && response.user != null) {
        await widget.authService.saveUserData(response.user!);
        setState(() {
          _isSuccess = true;
          _responseMessage = response.message;
          print(_responseMessage);
        });

        if (mounted) {
          Future.delayed(const Duration(milliseconds:200), () {
            Navigator.pushReplacementNamed(context, '/home');
          });
        }
      } else {
        setState(() {
          _isSuccess = false;
          _responseMessage = response.errors?.join('\n') ?? response.message;
        });
      }
    } catch (e) {
      setState(() {
        _isSuccess = false;
        _responseMessage = 'Network error: Check Your Internet Connection';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFields.emailField(controller: _emailController  ,context: context),
          // EmailField(controller: _emailController),
          const SizedBox(height: 16),

          CustomFields.passwordField( context: context, controller: _passwordController , obscureText: false , onToggleVisibility: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },),
          // PasswordField(
          //   controller: _passwordController,
          //   obscureText: _obscurePassword,
          //   onToggleVisibility: () {
          //     setState(() {
          //       _obscurePassword = !_obscurePassword;
          //     });
          //   },
          //   label: '',
          // ),
          const SizedBox(height: 24),

          CustomFields.loginButton(isLoading: _isLoading, onPressed: _loginUser, context: context),
          // LoginButton(isLoading: _isLoading, onPressed: _loginUser),
          const SizedBox(height: 24),

          CustomFields.registerPrompt(context,),
          // const RegisterPrompt(),
          const SizedBox(height: 16),
          if (_responseMessage.isNotEmpty)
            CustomFields.responseMessage(message: _responseMessage, isSuccess: _isSuccess, context: context)
            // ResponseMessage(message: _responseMessage, isSuccess: _isSuccess),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
