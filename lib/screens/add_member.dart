import 'package:intl/intl.dart';
import 'package:sfpo/constants/packages.dart';

class AddMember extends StatefulWidget {
  const AddMember({Key? key}) : super(key: key);

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final CollectionReference _membersRef = FirebaseFirestore.instance
      .collection("fpos")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("members");

  var dashboardScreen = DashboardScreen();
  final _addMemberFormKey = GlobalKey<FormState>();
  File? _imageFile;
  String? _memImgUrl;
  int _memId = 0;
  final _fullNameController = TextEditingController();
  final _surnameController = TextEditingController();
  String? _gender;
  String? _maritalStatus;
  final _fatherOrHusbandNameController = TextEditingController();
  final _aadharController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _dobController = TextEditingController();
  final _landHoldingController = TextEditingController();
  String? _country;
  String? _state;
  String? _district;
  String? _mandal;
  String? _revenueVillage;
  String? _habitation;
  final _joiningDateController = TextEditingController();
  final _membershipController = TextEditingController();
  final _shareCapitalController = TextEditingController();

  bool _registerFormLoading = false;

  Future getMembersCount() async {
    QuerySnapshot memSnap = await _membersRef.get();
    setState(() {
      _memId = memSnap.size;
    });
  }

  final maritalStatusTitle = [
    "S/o",
    "W/o",
  ];

  String fatherOrHusbandNameHintText() {
    if (_gender == "Female" && _maritalStatus == "Married") {
      return "Husband name";
    }
    return "Father name";
  }

  String maritalTitle() {
    if (fatherOrHusbandNameHintText() == "Father name" && _gender == "Female") {
      return "D/o";
    } else if (fatherOrHusbandNameHintText() == "Husband name") {
      return "W/o";
    }
    return "S/o";
  }

  List<String> _countries = [];

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
    _state = _states[0];
  }

  List<String> _districts = [];

  districtDependentDropdown(stateName) {
    districts.forEach((key, value) {
      if (stateName == value) {
        _districts.add(key);
      }
    });
    _district = _districts[0];
  }

  List<String> _mandals = [];

  mandalDependentDropdown(districtName) {
    mandals.forEach((key, value) {
      if (districtName == value) {
        _mandals.add(key);
      }
    });
    _mandal = _mandals[0];
  }

  List<String> _revenueVillages = [];

  revenueVillagesDependentDropdown(mandalName) {
    revenueVillages.forEach((key, value) {
      if (mandalName == value) {
        _revenueVillages.add(key);
      }
    });
    _revenueVillage = _revenueVillages[0];
  }

  List<String> _habitations = [];

  habitationDependentDropdown(revenueVillageName) {
    habitations.forEach((key, value) {
      if (revenueVillageName == value) {
        _habitations.add(key);
      }
    });
    _habitation = _habitations[0];
  }

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        _imageFile = File(croppedImage.path);
      });
    }
  }

  Future<String?> _createAccount() async {
    if (_imageFile == null) {
      return 'Please upload member photo';
    } else if (_fullNameController.text.isEmpty) {
      return 'Please enter member full name';
    } else if (_surnameController.text.isEmpty) {
      return 'Please enter member surname name';
    } else if (_gender == null) {
      return 'Please select member gender';
    } else if (_maritalStatus == null) {
      return 'Please select member marital status';
    } else if (_fatherOrHusbandNameController.text.isEmpty) {
      return 'Please enter father or husband name';
    } else if (_aadharController.text.isEmpty) {
      return 'Please enter member aadhar number';
    } else if (_mobileNumberController.text.isEmpty) {
      return 'Please enter member mobile number';
    } else if (_dobController.text.isEmpty) {
      return 'Please select member date of birth';
    } else if (_landHoldingController.text.isEmpty) {
      return 'Please enter land holding in acres';
    } else if (_country == null) {
      return 'Please select member country';
    } else if (_state == null) {
      return 'Please select member state';
    } else if (_district == null) {
      return 'Please select member district';
    } else if (_mandal == null) {
      return 'Please select member mandal';
    } else if (_revenueVillage == null) {
      return 'Please select member revenue village';
    } else if (_habitation == null) {
      return 'Please select member habitation';
    } else if (_joiningDateController.text.isEmpty) {
      return 'Please select member joining date';
    } else if (_membershipController.text.isEmpty) {
      return 'Please enter membership amount in rupees';
    } else if (_shareCapitalController.text.isEmpty) {
      return 'Please enter share capital amount in rupees';
    }

    try {
      final document = await _membersRef.doc();
      final uid = document.id;
      final memberImgRef = await FirebaseStorage.instance
          .ref()
          .child("memberImages")
          .child("$uid.jpg");
      await memberImgRef.putFile(_imageFile!);
      _memImgUrl = await memberImgRef.getDownloadURL();

      await _membersRef.doc(uid).set({
        'memId': ++_memId,
        'memberUid': uid,
        'memImgUrl': _memImgUrl,
        'fullName': _fullNameController.text.trim(),
        'surname': _surnameController.text.trim(),
        'gender': _gender,
        'maritalStatus': _maritalStatus,
        'maritalTitle': maritalTitle(),
        'fatherOrHusbandName': _fatherOrHusbandNameController.text.trim(),
        'aadhar': int.parse(_aadharController.text.trim()),
        'mobile': int.parse(_mobileNumberController.text.trim()),
        'dob': _dobController.text.trim(),
        'landHolding': double.parse(_landHoldingController.text.trim()),
        'country': _country,
        'state': _state,
        'district': _district,
        'mandal': _mandal,
        'revenueVillage': _revenueVillage,
        'habitation': _habitation,
        'joiningDate': _joiningDateController.text.trim(),
        'membership': int.parse(_membershipController.text.trim()),
        'shareCapital': int.parse(_shareCapitalController.text.trim()),
        'createdAt': Timestamp.now(),
      }).whenComplete(() async {
        final snackBar = await SnackBar(
          content: Text("Member added successfully"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError((error) async {
        final snackBar = await SnackBar(
          content: Text("Member not added: $error"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email';
      } else if (e.code == 'invalid-email') {
        return 'Email address is invalid';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  void _submitForm() async {
    setState(() {
      _registerFormLoading = true;
    });
    String? _createAccountFeedback = await _createAccount();
    if (_createAccountFeedback != null) {
      alertDialogBuilder(context, _createAccountFeedback);
      setState(() {
        _registerFormLoading = false;
      });
    } else {
      Navigator.canPop(context) ? Navigator.pop(context) : null;
    }
  }

  @override
  void initState() {
    getMembersCount();
    countryDependentDropdown();
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _surnameController.dispose();
    _fatherOrHusbandNameController.dispose();
    _aadharController.dispose();
    _mobileNumberController.dispose();
    _dobController.dispose();
    _landHoldingController.dispose();
    _joiningDateController.dispose();
    _membershipController.dispose();
    _shareCapitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.medium(
            title: Text('Add Member', style: TextStyle(color: accentColor)),
          ),
          SliverToBoxAdapter(
            child: Form(
              key: _addMemberFormKey,
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Container(
                          width: 130,
                          height: 130,
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _imageFile == null
                                    ? const Icon(
                                        Icons.add_a_photo_outlined,
                                        color: secondaryColor,
                                        size: 40,
                                      )
                                    : Expanded(
                                        child: Image.file(
                                          _imageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Please choose an option",
                                style: regularHeading),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  child: Row(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.camera,
                                            color: secondaryColor),
                                      ),
                                      Text("Camera", style: regularDarkText)
                                    ],
                                  ),
                                  onTap: () {
                                    _getFromCamera();
                                  },
                                ),
                                InkWell(
                                  child: Row(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.image,
                                            color: secondaryColor),
                                      ),
                                      Text("Gallery", style: regularDarkText)
                                    ],
                                  ),
                                  onTap: () {
                                    _getFromGallery();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  CustomFormField(
                    obscureText: false,
                    controller: _fullNameController,
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
                    controller: _surnameController,
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
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value.toString();
                          });
                        },
                      ),
                      const Text("Male", style: radioText),
                      Radio(
                        activeColor: primaryColor,
                        value: "Female",
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value.toString();
                          });
                        },
                      ),
                      const Text("Female", style: radioText),
                      Radio(
                        activeColor: primaryColor,
                        value: "Others",
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value.toString();
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
                        groupValue: _maritalStatus,
                        onChanged: (value) {
                          setState(() {
                            _maritalStatus = value.toString();
                          });
                        },
                      ),
                      const Text("Married", style: radioText),
                      Radio(
                        activeColor: primaryColor,
                        value: "Unmarried",
                        groupValue: _maritalStatus,
                        onChanged: (value) {
                          setState(() {
                            _maritalStatus = value.toString();
                          });
                        },
                      ),
                      const Text("Unmarried", style: radioText),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    obscureText: false,
                    controller: _fatherOrHusbandNameController,
                    title: (_gender == "Female" && _maritalStatus == "Married")
                        ? "Husband name"
                        : "Father name",
                    mandatorySymbol: " *",
                    hintText:
                        (_gender == "Female" && _maritalStatus == "Married")
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
                    controller: _aadharController,
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
                      return (value!.isEmpty ||
                              !RegExp(r'^[0-9]+$').hasMatch(value))
                          ? "Please enter valid aadhar number"
                          : null;
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    obscureText: false,
                    controller: _mobileNumberController,
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
                      return (value!.isEmpty ||
                              !RegExp(r'^[0-9]+$').hasMatch(value))
                          ? "Please enter 10 digit mobile number"
                          : null;
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    obscureText: false,
                    controller: _dobController,
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
                        initialDate: DateTime(2004),
                        firstDate: DateTime(1962),
                        lastDate: DateTime(2004),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dobController.text =
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
                    controller: _landHoldingController,
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
                    dropDownContainerWidth:
                        MediaQuery.of(context).size.width / 1.065,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSelected: (onSelected) {
                      setState(() {
                        _states = [];
                        stateDependentDropdown(countries[onSelected]);
                        _country = onSelected;
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
                    dropDownContainerWidth:
                        MediaQuery.of(context).size.width / 1.065,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSelected: (onSelected) {
                      setState(() {
                        _districts = [];
                        districtDependentDropdown(onSelected);
                        _state = onSelected;
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
                    dropDownContainerWidth:
                        MediaQuery.of(context).size.width / 1.065,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSelected: (onSelected) {
                      setState(() {
                        _mandals = [];
                        mandalDependentDropdown(onSelected);
                        _district = onSelected;
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
                    dropDownContainerWidth:
                        MediaQuery.of(context).size.width / 1.065,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSelected: (onSelected) {
                      setState(() {
                        _revenueVillages = [];
                        revenueVillagesDependentDropdown(onSelected);
                        _mandal = onSelected;
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
                    dropDownContainerWidth:
                        MediaQuery.of(context).size.width / 1.065,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSelected: (onSelected) {
                      setState(() {
                        _habitations = [];
                        habitationDependentDropdown(onSelected);
                        _revenueVillage = onSelected;
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
                    dropDownContainerWidth:
                        MediaQuery.of(context).size.width / 1.065,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSelected: (onSelected) {
                      setState(() {
                        _habitation = onSelected;
                      });
                    },
                    validator: (String? value) {
                      return (value!.isEmpty ||
                              !RegExp(r'^[a-z A-Z.]+$').hasMatch(value))
                          ? "Please enter valid text"
                          : null;
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    obscureText: false,
                    controller: _joiningDateController,
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
                          _joiningDateController.text =
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
                    controller: _membershipController,
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
                      return (value!.isEmpty ||
                              !RegExp(r'^(100)$').hasMatch(value))
                          ? "Membership must be 100"
                          : null;
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomFormField(
                    obscureText: false,
                    controller: _shareCapitalController,
                    title: "Share capital",
                    mandatorySymbol: " *",
                    hintText: "Share capital",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    icon: const Icon(Icons.currency_rupee),
                    keyboardType: TextInputType.number,
                    fillColor: fieldBackgroundColor,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.done,
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
                      _submitForm();
                      setState(() {
                        _registerFormLoading = true;
                      });
                    },
                    isLoading: _registerFormLoading,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
