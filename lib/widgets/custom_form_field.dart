import 'package:sfpo/constants/packages.dart';

class CustomFormField extends StatelessWidget {
  final String? title;
  final String? mandatorySymbol;
  final Widget? icon;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLength;
  final String? counterText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Color? fillColor;
  final AutovalidateMode? autovalidateMode;
  final TextCapitalization textCapitalization;

  const CustomFormField({
    Key? key,
    this.title,
    this.mandatorySymbol,
    this.icon,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.controller,
    this.onTap,
    this.textInputAction,
    this.maxLength,
    this.counterText,
    this.focusNode,
    this.initialValue,
    this.suffixIcon,
    this.onEditingComplete,
    required this.obscureText,
    this.fillColor,
    this.autovalidateMode,
    required this.textCapitalization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Row(
            children: [
              Text(title!, style: fieldsTitleText),
              Text(mandatorySymbol!, style: errorTextStyle),
            ],
          ),
        ),
        TextFormField(
          textInputAction: textInputAction,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLength: maxLength,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            icon: icon,
            filled: true,
            suffixIcon: suffixIcon,
            fillColor: fillColor,
            hintText: hintText,
            hintStyle: fieldsHintText,
            errorStyle: errorTextStyle,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: secondaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: errorTextColor),
              borderRadius: BorderRadius.circular(8),
            ),
            counterText: counterText,
          ),
          validator: validator,
          style: fieldsText,
          controller: controller,
          onTap: onTap,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
        ),
      ],
    );
  }
}
