

import 'package:flutter/material.dart';


class FormTextFieldDecoration{

  InputDecoration decoration({String labelText}){
    return InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13.0),
            borderSide: BorderSide()
        )
    );
  }
}