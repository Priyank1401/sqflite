import 'package:flutter/material.dart';

class Utils {

  static List<String> weightList = [
    'Select Unit',
    'Kg',
    'gm',
    'L',
    'ml',
    'NA'
  ];

  static List<String> monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static void showDialogAlert(BuildContext context, Widget dialog) {
    showGeneralDialog(
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
                opacity: a1.value,
                child: dialog
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {return const SizedBox();});
  }

}