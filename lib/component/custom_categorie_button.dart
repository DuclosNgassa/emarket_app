import 'package:flutter/material.dart';

class CustomCategorieButton extends StatelessWidget {
  CustomCategorieButton(
      {@required this.onPressed,
      @required this.width,
      @required this.height,
      @required this.fillColor,
      @required this.splashColor,
      @required this.icon,
      @required this.iconColor,
      @required this.text,
      @required this.textStyle});

  final GestureTapCallback onPressed;
  final double width;
  final double height;
  final Color fillColor;
  final Color splashColor;
  final Color iconColor;
  final IconData icon;
  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      //fillColor: fillColor,
      splashColor: splashColor,
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: fillColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Container(
              width: width + 10,
              height: height,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              child: Text(
                text,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
