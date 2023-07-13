import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

//TODO: Maybe replace all the alertdialogs and SnackBars with this awesome dialog.

class CustomAwesomeDialog {

  final BuildContext context;
  final DialogType dialogType;
  final String title;
  final String desc;

  const CustomAwesomeDialog({required this.context,
    required this.dialogType, required this.title, required this.desc});

  AwesomeDialog buildAlertDialog() {
    return AwesomeDialog(
      context: context,
      dialogType: dialogType,
      title: title,
      desc: desc,
      borderSide: const BorderSide(
        color: Colors.green,
        width: 2,
      ),
      width: 280,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      animType: AnimType.bottomSlide,
      showCloseIcon: true,
    );
  }
}