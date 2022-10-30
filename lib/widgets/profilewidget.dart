import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {

  const ProfileWidget({
    required this.text,
    required this.icon,
    required this.icon_end,
    required this.click,
  });
  final String text;
  final IconData icon;
  final IconData icon_end;
  final VoidCallback click;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(

        style: TextButton.styleFrom(
          primary:Colors.black,
          padding: EdgeInsets.all(20),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        //  onPressed: press,
        onPressed: click,
        child: Row(
          children: [
            Icon(icon ,size: 22.0,color: Colors.black,),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(icon_end),

          ],
        ),
      ),
    );
  }
}
