import 'package:flutter/material.dart';
import 'package:shop/screens/auth_screen.dart';

class SwitchAuthModeText extends StatelessWidget {
  const SwitchAuthModeText({
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _authMode == AuthMode.Login
              ? 'Don\'t have an account?'
              : 'Already have an account?',
        ),
        TextButton(
            onPressed: _onPressed,
            child: Text(
              _authMode == AuthMode.Login ? 'Register' : 'Log in',
            ))
      ],
    );
  }
}
