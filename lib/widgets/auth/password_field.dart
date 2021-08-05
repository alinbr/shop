import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    Key key,
    @required TextEditingController passwordController,
    @required Map<String, String> authData,
  })  : _passwordController = passwordController,
        _authData = authData,
        super(key: key);

  final TextEditingController _passwordController;
  final Map<String, String> _authData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoFormRow(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CupertinoTextFormFieldRow(
              obscureText: true,
              placeholder: 'Password',
              controller: _passwordController,
              padding: EdgeInsets.all(0),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => (value.isEmpty || value.length < 5)
                  ? 'Password is too short!'
                  : null,
              onSaved: (value) {
                _authData['password'] = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
