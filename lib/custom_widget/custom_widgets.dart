import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

typedef ValidationRule = Tuple2<String, String>;

class CustomWidget {

  static Widget commonTextFormField({
    required BuildContext context,
    Widget? suffixIcon,
    Icon? prefixIcon,
    String? hintText,
    Widget? suffixWidget,
    Widget? prefixWidget,
    TextInputAction? textInputAction,
    TextEditingController? textFieldController,
    Function? validation,
    TextInputType? keyboardType,
    bool allowValidation = true,
    bool obscureText = false,
    String? errorMessage,
    String? valueMessage,
    int? length,
    String? initialVal,
    int? value,
    String? lengthMessage,
    String? validationRegex,
    String? validationMessage,
    String? emptyMessage,
    String? containMessage,
    String? returnContainMessage,
    String? passwordMessage,
    Function? suffixIconOnTap,
    String? labelText,
    Function? textFieldCallback,
    Function? onChanged,
    Function? onFieldSubmitted,
    Function? onEditingComplete,
    FocusNode? focusNode,
    TextEditingController? comparisonController,
    String? comparisonErrorMessage,
    String? regexContain,
    String? anotherRegexContain,
    String? regexContainErrorMessage,
    String? anotherRegexContainErrorMessage,
    List<ValidationRule>? validationRules,
    // int? maxLines,
    int? maxLength,
    bool readOn = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        validator: (text) {
          if (textFieldController!.text.trim().isEmpty && allowValidation) {
            return errorMessage ?? "Invalid Input";
          } else if (value != null &&
              (int.parse(textFieldController.text.trim()) > value)) {
            return valueMessage ?? "Invalid Input";
          } else if (length != null && lengthMessage != null) {
            if (textFieldController.text.trim().length < length ||
                textFieldController.text.trim().length > length) {
              return lengthMessage;
            }
          } else if (validationRegex != null) {
            if (!RegExp(validationRegex).hasMatch(text!.trim())) {
              return validationMessage ?? 'Invalid Input';
            }
          } else if (comparisonController != null &&
              textFieldController.text.trim() !=
                  comparisonController.text.trim()) {
            return comparisonErrorMessage ?? 'Fields do not match';
          } else if (validationRules != null) {
            for (var rule in validationRules) {
              final regex = rule.item1;
              if (!RegExp(regex).hasMatch(text!.trim())) {
                return rule.item2 ?? 'Invalid Input';
              }
            }
          }
          return null;
        },
        keyboardType: keyboardType,
        maxLength:maxLength ,
        // maxLines: maxLines,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: textInputAction,
        controller: textFieldController,
        initialValue: initialVal,
        obscureText: obscureText,
        focusNode: focusNode,
        readOnly: readOn,
        onEditingComplete: () {
          onEditingComplete?.call();
        },
        onFieldSubmitted: (value) {
          onFieldSubmitted?.call(value);
        },
        onTap: () {
          textFieldCallback?.call();
        },
        onChanged: (value) {
          onChanged?.call(value);
        },
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.transparent, width: 0)),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.transparent)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            suffixIcon: suffixIcon,
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffix: suffixWidget,
            prefix: prefixWidget,
            // fillColor: ,
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10)),
            hintText: hintText,
            hintStyle: const TextStyle(
                color: Color(0x993C3C43), fontSize: 16, fontWeight: FontWeight.w400)),
      ),
    );
  }







  static Widget commonText(
      {required String commonText,
        TextOverflow? textOverflow,
        Color? color,
        TextAlign? textAlign,
        String? fontFamily,
        TextDecoration? textDecoration,
        double? fontSize,
        FontStyle? fontStyle,
        double? height,
        FontWeight? fontWeight,
        Function? textOnTap,
        Function? textOnLongPress,
        TextOverflow? overflow,
        double? wordSpacing,
        int? maxLines,
        bool? softWrap,
        TextLeadingDistribution? leadingDistribution}) {
    return InkWell(
      onLongPress: () {
        textOnLongPress?.call();
      },
      onTap: () {
        textOnTap?.call();
      },
      child: Text(
        commonText,
        overflow: textOverflow,
        textAlign: textAlign,
        maxLines: maxLines,
        softWrap: softWrap,
        style: TextStyle(
          fontFamily: fontFamily,
          color: color,
          decoration: textDecoration,
          fontSize: fontSize,
          fontStyle: fontStyle,
          height: height,
          fontWeight: fontWeight,
          overflow: overflow,
          wordSpacing: wordSpacing,
          leadingDistribution: leadingDistribution,
        ),
        textScaleFactor: 1.0,
      ),
    );
  }

  static Widget commonElevatedButton(
      {required BuildContext context,
        required String buttonText,
        Color? buttonTextColor,
        double? buttonFontSize,
        FontWeight? buttonFontWeight,
        Function? onTap,
        Color? buttonColor = Colors.deepPurple,
        Function(bool)? onFocusChange,
        FocusNode? focusNode}) {
    return ElevatedButton(
        focusNode: focusNode,
        onFocusChange: (bool hasFocus) {
          onFocusChange?.call(hasFocus);
        },
        autofocus: true,
        style: const ButtonStyle(
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)))),
        ),
        onPressed: () {
          onTap?.call();
        },
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 20,
              color: buttonTextColor),
        ));
  }
}

// decoration: BoxDecoration(border: Border.all(width: 1)),
