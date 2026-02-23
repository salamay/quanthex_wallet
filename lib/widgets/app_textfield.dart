import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextfield extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final bool obscurePassword;
  final Widget? suffixIcon;
  final double? radius;
  final Color? filledColor;
  final Color? borderColor;
  final bool? readonly;
  final bool? isdense, useFill;
  final Function()? onTap;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextStyle? textStyle;
  final int? maxLines;
  final int? maxLength;
  final InputBorder? border;
  final bool isPassword;
  final TextStyle? hintStyle;
  final bool? filled;
  final FocusNode? focusNode;
  int? errorMaxLines;
  bool? enable;
  TextAlign? textAlign;

  AppTextfield({
    super.key,
    this.focusNode,
    this.hintText = '',
    this.errorText,
    this.obscurePassword = false,
    this.suffixIcon,
    this.radius,
    this.filledColor,
    this.borderColor,
    this.readonly,
    this.onTap,
    this.isdense,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.contentPadding,
    this.validator,
    this.keyboardType,
    this.maxLength,
    this.maxLines,
    this.textStyle,
    this.hintStyle,
    this.border,
    this.isPassword = false,
    this.controller,
    this.useFill,
    this.filled,
    this.errorMaxLines,
    this.enable,
    this.textAlign,
  });

  @override
  State<AppTextfield> createState() => _AppTextfieldState();
}

class _AppTextfieldState extends State<AppTextfield> {
  late bool showPassword;

  @override
  void initState() {
    super.initState();
    showPassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      focusNode: widget.focusNode,
      enabled: widget.enable ?? true,
      // key: key,
      readOnly: widget.readonly ?? false,
      // cursorColor: const Color(0xffAEACAC),
      onChanged: widget.onChanged,
      textAlign: widget.textAlign ?? TextAlign.start,
      obscureText: widget.isPassword ? showPassword : widget.obscurePassword,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: widget.textStyle ?? const TextStyle(color: Color(0xFF6F6F6F)),
      textInputAction: TextInputAction.done,
      maxLines: widget.isPassword || widget.obscurePassword ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,

      decoration: InputDecoration(
        contentPadding: widget.contentPadding,
        
        isDense: widget.isdense,
        errorMaxLines: widget.errorMaxLines ?? 3,
        hintText: widget.hintText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        filled: widget.useFill ?? true,
        fillColor: widget.filledColor ?? Colors.white,
        prefixIconColor: const Color(0xffBEC1CD),
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                child: Icon(showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Color(0xffC6C6C6)),
              )
            : widget.suffixIcon,
        suffixIconColor: Colors.black,
        hintStyle: widget.hintStyle ?? TextStyle(
          color: const Color(0xFF6F6F6F),
           fontSize: 14.sp, 
           fontFamily: 'SF Pro', 
           fontWeight: FontWeight.w400,
           ),
        errorStyle: TextStyle(color: Colors.red, fontSize: 10.sp, fontFamily: 'SF Pro', fontWeight: FontWeight.w400),
        focusedBorder:
            widget.border ??
            OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: widget.borderColor ?? const Color(0xFFEAEAEA)),
              borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 25)),
            ),
        enabledBorder:
            widget.border ??
            OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: widget.borderColor ?? const Color(0xFFEAEAEA)),
              borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 25)),
            ),
        border:
            widget.border ??
            OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: widget.borderColor ?? const Color(0xFFEAEAEA)),
              borderRadius: BorderRadius.all(
                Radius.circular(widget.radius ?? 25), //C3C7E5
              ),
            ),
      ),
    );
  }
}
         
         
//               OutlineInputBorder(
//                 borderSide = BorderSide(
//                   width: 0.5,
//                   color: borderColor ?? const Color(0xFFF3F3F3),
//                 ),
//                 borderRadius = BorderRadius.all(Radius.circular(radius ?? 16)),
//               ),
//           enabledBorder:
//               border ??
//               OutlineInputBorder(
//                 borderSide = BorderSide(
//                   width: 0.5,
//                   color: borderColor ?? const Color(0xFFF3F3F3),
//                 ),
//                 borderRadius = BorderRadius.all(Radius.circular(radius ?? 16)),
//               ),
//           border:
//               border ??
//               OutlineInputBorder(
//                 borderSide = BorderSide(
//                   width: 0.5,
//                   color: borderColor ?? const Color(0xFFF3F3F3),
//                 ),
//                 borderRadius = BorderRadius.all(
//                   Radius.circular(radius ?? 16), //C3C7E5
//                 ),
//               ),
//         ),
//       );
//     });
//   }
// }
// }