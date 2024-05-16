import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

showToastMessage(String message, BuildContext context){
 return toastification.show(
  context: context, // optional if you use ToastificationWrapper
  title: Text(message),
  autoCloseDuration: const Duration(seconds: 5),
  alignment: Alignment.topCenter,
);
} 