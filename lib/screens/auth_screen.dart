import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/providers_riverpod/auth_controller.dart';
import 'package:shop/widgets/auth/confirm_password.dart';
import 'package:shop/widgets/auth/email_field.dart';
import 'package:shop/widgets/auth/login_register_button.dart';
import 'package:shop/widgets/auth/password_field.dart';
import 'package:shop/widgets/auth/switch_auth_mode_text.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends ConsumerWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFebedee),
              Color(0xFFfdfbfb),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 120,
            ),
            Text(
              'Welcome to my shop.',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Let\'s get you started!',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 48,
            ),
            Expanded(child: AuthCard()),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends ConsumerStatefulWidget {
  const AuthCard({Key key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends ConsumerState<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(0.3, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurrred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'))
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      print("invalid");
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        ref
            .watch(authProvider)
            .signIn(_authData['email'], _authData['password']);
      } else {
        // Sign user up
        ref
            .watch(authProvider)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Auth failed';
      if (error.message.contains('EMAIL_EXISTS')) {
        errorMessage = 'Email already registered';
      } else if (error.message.contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid email';
      } else if (error.message.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'No user with that email address';
      } else if (error.message.contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not auth you. try later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          EmailField(authData: _authData),
          SizedBox(
            height: 16,
          ),
          PasswordField(
              passwordController: _passwordController, authData: _authData),
          SizedBox(
            height: 16,
          ),
          ConfirmPassword(
              authMode: _authMode,
              opacityAnimation: _opacityAnimation,
              slideAnimation: _slideAnimation,
              passwordController: _passwordController),
          Expanded(
            child: Container(),
          ),
          SwitchAuthModeText(authMode: _authMode, onPressed: _switchAuthMode),
          if (_isLoading)
            CircularProgressIndicator(
              color: Colors.black87,
            )
          else
            LoginRegisterButton(
              authMode: _authMode,
              onPressed: _submit,
            ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
