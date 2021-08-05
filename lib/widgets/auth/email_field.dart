import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    Key key,
    @required Map<String, String> authData,
  })  : _authData = authData,
        super(key: key);

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
              placeholder: 'Email',
              padding: EdgeInsets.all(0),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => (value.isEmpty || !value.contains('@'))
                  ? 'Invalid email!'
                  : null,
              onSaved: (value) {
                _authData['email'] = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
