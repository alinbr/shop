import 'package:flutter/material.dart';
import 'package:shop/screens/auth_screen.dart';

class LoginRegisterButton extends StatelessWidget {
  const LoginRegisterButton({
    Key key,
    @required AuthMode authMode,
    @required Function onPressed,
  })  : _authMode = authMode,
        _onPressed = onPressed,
        super(key: key);

  final AuthMode _authMode;
  final Function _onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          primary: Colors.black87,
        ),
        onPressed: _onPressed,
        child: Text(_authMode == AuthMode.Login ? 'Sign in' : 'Register'),
      ),
    );
  }
}
