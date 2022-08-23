import 'package:sfpo/constants/packages.dart';

class CustomAutoCompleteField extends StatelessWidget {
  final String title;
  final String mandatorySymbol;
  final List<String> itemList;
  final String hintText;
  final void Function(String)? onSelected;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final Color? fillColor;
  final Widget? icon;
  final double? dropDownContainerHeight;
  final double? dropDownContainerWidth;

  const CustomAutoCompleteField({
    Key? key,
    required this.title,
    required this.mandatorySymbol,
    required this.itemList,
    required this.hintText,
    this.onSelected,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.fillColor,
    this.autovalidateMode,
    this.icon,
    this.dropDownContainerWidth,
    this.dropDownContainerHeight,
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
        Autocomplete<String>(
          optionsBuilder: (textEditingValue) {
            (textEditingValue.text.isEmpty) ? [] : null;
            return itemList.where((value) => value
                .toLowerCase()
                .startsWith(textEditingValue.text.toLowerCase()));
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              style: fieldsText,
              decoration: InputDecoration(
                filled: true,
                fillColor: fillColor,
                icon: icon,
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
              ),
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              autovalidateMode: autovalidateMode,
              validator: validator,
            );
          },
          optionsViewBuilder: (context, onSelected, name) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                  width: dropDownContainerWidth,
                  height: 250,
                  color: accentColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: name.length,
                    itemBuilder: (context, index) {
                      var option = name.elementAt(index);
                      return GestureDetector(
                        child: ListTile(
                          dense: true,
                          title: Text(option, style: fieldsText),
                        ),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          onSelected: onSelected,
        ),
      ],
    );
  }
}
