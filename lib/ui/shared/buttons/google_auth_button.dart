import 'package:flutter/material.dart';

class GoogleAuthButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const GoogleAuthButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: Colors.grey[300],
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('lib/assets/images/google_logo.png'),
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: Color(0xff545871),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
