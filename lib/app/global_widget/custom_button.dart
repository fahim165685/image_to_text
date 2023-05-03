import 'package:flutter/material.dart';

//ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.showBorderOnly = false,
    this.borderColor = Colors.deepPurple,
    this.buttonColor = Colors.deepPurple,
    this.fontColor,
    this.height = 56,
    this.borderRadius=6,
    this.borderWidth=2,
    this.icon,
  });

  final VoidCallback? onTap;
  final String text;
  final bool showBorderOnly;
  final Color borderColor;
  final Color buttonColor;
  final Color? fontColor;
  final double height;
  final double borderRadius;
  final double borderWidth;
  Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: showBorderOnly==false? buttonColor:null,
        borderRadius: BorderRadius.circular(borderRadius),
        border:showBorderOnly==true? Border.all(color: borderColor,width: borderWidth, ):null,
       ),
      child: Material(
        color: Colors.transparent,
        child:  InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child:  SizedBox(
            width: double.infinity,
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 4,),
                SizedBox(child: icon,),
                if((icon == null)==false)
                  const SizedBox(width: 6,),
                if(text.isEmpty==false)
                Flexible(
                  child: FittedBox(
                    child: Text(text,style: TextStyle(
                      color:(fontColor==null)?showBorderOnly==true?Colors.deepPurple:Colors.white:fontColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),),
                  ),
                ),
                const SizedBox(width: 8,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}