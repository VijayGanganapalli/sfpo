import 'package:sfpo/constants/packages.dart';

class CustomRadioButton extends StatefulWidget {
  final String? genderValue;
  const CustomRadioButton({
    Key? key,
    this.genderValue,
  }) : super(key: key);

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  var _genderValue = "";
  @override
  Widget build(BuildContext context) {
    return Radio(
      value: "Male",
      groupValue: _genderValue,
      onChanged: (value) {
        setState(() {
          _genderValue = value.toString();
        });
      },
      //activeColor: backgroundColor,
    );
  }
}
