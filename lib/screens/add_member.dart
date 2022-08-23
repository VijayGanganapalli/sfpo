import 'package:intl/intl.dart';
import 'package:sfpo/constants/packages.dart';

class AddMember extends StatefulWidget {
  const AddMember({Key? key}) : super(key: key);

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final addMemberFormKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final surnameController = TextEditingController();
  String? gender;
  String? maritalStatus;
  final fatherOrHusbandNameController = TextEditingController();
  final aadharController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final dobController = TextEditingController();
  final landHoldingController = TextEditingController();
  String country = "";
  String state = "";
  String district = "";
  String mandal = "";
  String revenueVillage = "";
  String habitation = "";
  final joiningDateController = TextEditingController();
  final membershipController = TextEditingController();
  final shareCapitalController = TextEditingController();
  bool registerFormLoading = false;

  final maritalStatusTitle = [
    "S/o",
    "W/o",
  ];

  final List<String> _countries = [];
  countryDependentDropdown() {
    countries.forEach((key, value) {
      _countries.add(key);
    });
  }

  List<String> _states = [];
  stateDependentDropdown(countryShortName) {
    states.forEach((key, value) {
      if (countryShortName == value) {
        _states.add(key);
      }
    });
    state = _states[0];
  }

  List<String> _districts = [];
  districtDependentDropdown(stateName) {
    districts.forEach((key, value) {
      if (stateName == value) {
        _districts.add(key);
      }
    });
    district = _districts[0];
  }

  List<String> _mandals = [];
  mandalDependentDropdown(districtName) {
    mandals.forEach((key, value) {
      if (districtName == value) {
        _mandals.add(key);
      }
    });
    mandal = _mandals[0];
  }

  List<String> _revenueVillages = [];
  revenueVillagesDependentDropdown(mandalName) {
    revenueVillages.forEach((key, value) {
      if (mandalName == value) {
        _revenueVillages.add(key);
      }
    });
    revenueVillage = _revenueVillages[0];
  }

  List<String> _habitations = [];
  habitationDependentDropdown(revenueVillageName) {
    habitations.forEach((key, value) {
      if (revenueVillageName == value) {
        _habitations.add(key);
      }
    });
    habitation = _habitations[0];
  }

  @override
  void initState() {
    countryDependentDropdown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Add member"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: addMemberFormKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            CustomFormField(
              obscureText: false,
              controller: fullNameController,
              title: "Full name",
              mandatorySymbol: " *",
              hintText: "Enter your full name",
              textCapitalization: TextCapitalization.none,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              icon: const Icon(Icons.person),
              fillColor: fieldBackgroundColor,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value))
                    ? "Please enter valid text"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomFormField(
              obscureText: false,
              controller: surnameController,
              title: "Surname",
              mandatorySymbol: " *",
              hintText: "Enter your surname",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              icon: const Icon(Icons.person),
              fillColor: fieldBackgroundColor,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value))
                    ? "Please enter valid text"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Text("Gender"),
                Text(" *", style: errorTextStyle),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: primaryColor,
                  value: "Male",
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                const Text("Male", style: radioText),
                Radio(
                  activeColor: primaryColor,
                  value: "Female",
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                const Text("Female", style: radioText),
                Radio(
                  activeColor: primaryColor,
                  value: "Others",
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                const Text("Others", style: radioText),
              ],
            ),
            Row(
              children: const [
                Text("Marital status"),
                Text(" *", style: errorTextStyle),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: primaryColor,
                  value: "Married",
                  groupValue: maritalStatus,
                  onChanged: (value) {
                    setState(() {
                      maritalStatus = value.toString();
                    });
                  },
                ),
                const Text("Married", style: radioText),
                Radio(
                  activeColor: primaryColor,
                  value: "Unmarried",
                  groupValue: maritalStatus,
                  onChanged: (value) {
                    setState(() {
                      maritalStatus = value.toString();
                    });
                  },
                ),
                const Text("Unmarried", style: radioText),
              ],
            ),
            const SizedBox(height: 8),
            CustomFormField(
              obscureText: false,
              controller: fatherOrHusbandNameController,
              title: (gender == "Female" && maritalStatus == "Married")
                  ? "Husband name"
                  : "Father name",
              mandatorySymbol: " *",
              hintText: (gender == "Female" && maritalStatus == "Married")
                  ? "Husband name"
                  : "Father name",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              icon: const Icon(Icons.person),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              fillColor: fieldBackgroundColor,
              textCapitalization: TextCapitalization.none,
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value))
                    ? "Please enter valid text"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomFormField(
              obscureText: false,
              controller: aadharController,
              title: "Aadhar",
              mandatorySymbol: " *",
              hintText: "Enter your aadhar number",
              fillColor: fieldBackgroundColor,
              icon: const Icon(Icons.badge_outlined),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textCapitalization: TextCapitalization.none,
              maxLength: 12,
              counterText: "",
              validator: (String? value) {
                return (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value))
                    ? "Please enter valid aadhar number"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomFormField(
              obscureText: false,
              controller: mobileNumberController,
              title: "Mobile",
              mandatorySymbol: " *",
              hintText: "Enter your mobile number",
              icon: const Icon(Icons.phone_android),
              keyboardType: TextInputType.number,
              fillColor: fieldBackgroundColor,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              maxLength: 10,
              counterText: "",
              validator: (String? value) {
                return (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value))
                    ? "Please enter 10 digit mobile number"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomFormField(
              obscureText: false,
              controller: dobController,
              title: "Date of birth",
              mandatorySymbol: " *",
              icon: const Icon(Icons.calendar_today_outlined),
              fillColor: fieldBackgroundColor,
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              hintText: "Date of birth",
              onTap: () async {
                FocusScope.of(context).unfocus();
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1960),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    dobController.text =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                  });
                }
              },
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^[0-9 -/.]+$').hasMatch(value))
                    ? "Please select your date of birth"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomFormField(
              obscureText: false,
              controller: landHoldingController,
              title: "Land holding",
              mandatorySymbol: " *",
              hintText: "Enter your land extent",
              icon: const Icon(Icons.area_chart_outlined),
              keyboardType: TextInputType.number,
              fillColor: fieldBackgroundColor,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 4,
              counterText: "",
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^[1-9]\d*(\.\d+)?$').hasMatch(value))
                    ? "Please enter valid aadhar number"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomAutoCompleteField(
              title: "Country",
              mandatorySymbol: " *",
              itemList: _countries,
              hintText: "Select your country",
              fillColor: fieldBackgroundColor,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              dropDownContainerWidth: MediaQuery.of(context).size.width / 1.065,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSelected: (onSelected) {
                setState(() {
                  _states = [];
                  stateDependentDropdown(countries[onSelected]);
                  country = onSelected;
                });
              },
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value))
                    ? "Please enter valid text"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomAutoCompleteField(
              title: "State",
              mandatorySymbol: " *",
              itemList: _states,
              hintText: "Select your state",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              fillColor: fieldBackgroundColor,
              dropDownContainerWidth: MediaQuery.of(context).size.width / 1.065,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSelected: (onSelected) {
                setState(() {
                  _districts = [];
                  districtDependentDropdown(onSelected);
                  state = onSelected;
                });
              },
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value))
                    ? "Please enter valid text"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomAutoCompleteField(
              title: "District",
              mandatorySymbol: " *",
              itemList: _districts,
              hintText: "Select your district",
              keyboardType: TextInputType.name,
              fillColor: fieldBackgroundColor,
              textInputAction: TextInputAction.next,
              dropDownContainerWidth: MediaQuery.of(context).size.width / 1.065,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSelected: (onSelected) {
                setState(() {
                  _mandals = [];
                  mandalDependentDropdown(onSelected);
                  state = onSelected;
                });
              },
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value))
                    ? "Please enter valid text"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomAutoCompleteField(
              title: "Mandal",
              mandatorySymbol: " *",
              itemList: _mandals,
              hintText: "Select your mandal",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              fillColor: fieldBackgroundColor,
              dropDownContainerWidth: MediaQuery.of(context).size.width / 1.065,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSelected: (onSelected) {
                setState(() {
                  _revenueVillages = [];
                  revenueVillagesDependentDropdown(onSelected);
                  mandal = onSelected;
                });
              },
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value))
                    ? "Please enter valid text"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomAutoCompleteField(
              title: "Revenue village",
              mandatorySymbol: " *",
              itemList: _revenueVillages,
              hintText: "Select your revenue village",
              keyboardType: TextInputType.name,
              fillColor: fieldBackgroundColor,
              textInputAction: TextInputAction.next,
              dropDownContainerWidth: MediaQuery.of(context).size.width / 1.065,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSelected: (onSelected) {
                setState(() {
                  _habitations = [];
                  habitationDependentDropdown(onSelected);
                  revenueVillage = onSelected;
                });
              },
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value))
                    ? "Please enter valid text"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomAutoCompleteField(
              title: "Habitation",
              mandatorySymbol: " *",
              itemList: _habitations,
              hintText: "Select your habitation",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              fillColor: fieldBackgroundColor,
              dropDownContainerWidth: MediaQuery.of(context).size.width / 1.065,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSelected: (onSelected) {
                setState(() {
                  habitation = onSelected;
                });
              },
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value))
                    ? "Please enter valid text"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomFormField(
              obscureText: false,
              controller: joiningDateController,
              title: "Joining date",
              mandatorySymbol: " *",
              icon: const Icon(Icons.calendar_today_outlined),
              keyboardType: TextInputType.datetime,
              fillColor: fieldBackgroundColor,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              hintText: "Joining date",
              onTap: () async {
                FocusScope.of(context).unfocus();
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2200),
                );
                if (pickedDate != null) {
                  setState(() {
                    joiningDateController.text =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                  });
                }
              },
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^[0-9 -/.]+$').hasMatch(value))
                    ? "Please select your joining date"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomFormField(
              obscureText: false,
              controller: membershipController,
              title: "Membership",
              mandatorySymbol: " *",
              hintText: "Membership",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              icon: const Icon(Icons.currency_rupee),
              keyboardType: TextInputType.number,
              fillColor: fieldBackgroundColor,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              maxLength: 3,
              counterText: "",
              validator: (String? value) {
                return (value!.isEmpty || !RegExp(r'^(100)$').hasMatch(value))
                    ? "Membership must be 100"
                    : null;
              },
            ),
            const SizedBox(height: 8),
            CustomFormField(
              obscureText: false,
              controller: shareCapitalController,
              title: "Share capital",
              mandatorySymbol: " *",
              hintText: "Share capital",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              icon: const Icon(Icons.currency_rupee),
              keyboardType: TextInputType.number,
              fillColor: fieldBackgroundColor,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              maxLength: 4,
              counterText: "",
              validator: (String? value) {
                return (value!.isEmpty ||
                        !RegExp(r'^([0]|10[0]|20[0]|30[0]|40[0]|50[0]|60[0]|70[0]|80[0]|90[0]|1000)$')
                            .hasMatch(value))
                    ? "Share capital is between 100 to 1000"
                    : null;
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              buttonText: "Submit",
              outlineButton: false,
              onPressed: () {
                if (addMemberFormKey.currentState!.validate()) {
                  const snackBar =
                      SnackBar(content: Text("Submitted successfully"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
