import 'package:sfpo/constants/packages.dart';

class CustomDropdownField extends StatelessWidget {
  final String title;
  final String mandatorySymbol;
  final String hintText;
  final String selectedItem;
  final List<dynamic> itemList;
  final void Function(dynamic) onChanged;

  const CustomDropdownField({
    Key? key,
    required this.title,
    required this.mandatorySymbol,
    required this.onChanged,
    required this.selectedItem,
    required this.itemList,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(title, style: fieldsTitleText),
            Text(mandatorySymbol, style: errorTextStyle),
          ],
        ),
        Container(
          color: fieldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              iconEnabledColor: fieldsHintColor,
              dropdownColor: fieldBackgroundColor,
              hint: Text(hintText, style: fieldsHintText),
              value: selectedItem,
              items: itemList.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item, style: fieldsText),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
