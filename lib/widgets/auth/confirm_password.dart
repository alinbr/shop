import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/screens/auth_screen.dart';

class ConfirmPassword extends StatelessWidget {
  const ConfirmPassword({
    Key key,
    @required AuthMode authMode,
    @required Animation<double> opacityAnimation,
    @required Animation<Offset> slideAnimation,
    @required TextEditingController passwordController,
  })  : _authMode = authMode,
        _opacityAnimation = opacityAnimation,
        _slideAnimation = slideAnimation,
        _passwordController = passwordController,
        super(key: key);

  final AuthMode _authMode;
  final Animation<double> _opacityAnimation;
  final Animation<Offset> _slideAnimation;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _authMode == AuthMode.Signup ? 60 : 0,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: _authMode == AuthMode.Signup
            ? FadeTransition(
                opacity: _opacityAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoFormRow(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: CupertinoTextFormFieldRow(
                          obscureText: true,
                          placeholder: 'Confirm Password',
                          padding: EdgeInsets.all(0),
                          keyboardType: TextInputType.emailAddress,
                          validator: _authMode == AuthMode.Signup
                              ? (value) => (value != _passwordController.text)
                                  ? 'Passwords do not match!'
                                  : null
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container());
  }
}
