import 'package:intl/intl.dart';
import 'package:sfpo/constants/packages.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registrationFormKey = GlobalKey<FormState>();
  File? imageFile;
  String? logoURL;
  final _fpoShortNameController = TextEditingController();
  final _fpoFullNameController = TextEditingController();
  String? _registrationType;
  final _regNumController = TextEditingController();
  final _regDateController = TextEditingController();
  final _panController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactNumController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _registerFormLoading = false;
  bool _passwordVisibility = true;

  final List<String> _registrationTypes = [
    "Cooperative Societies Act",
    "Indian Companies Act",
  ];

  bool _passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future<String?> _createAccount() async {
    if (imageFile == null) {
      return 'Please pick your fpo logo';
    }
    if (!_passwordConfirmed()) {
      return 'Password and confirm password should be same';
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text.trim(),
      );
      final User? user = FirebaseAuth.instance.currentUser!;
      final _uid = user!.uid;

      final fpoLogosRef = await FirebaseStorage.instance
          .ref()
          .child("fpoLogos")
          .child(
              "${_fpoShortNameController.text.trim().toLowerCase().replaceAll(' ', '')}.jpg");
      await fpoLogosRef.putFile(imageFile!);
      logoURL = await fpoLogosRef.getDownloadURL();
      FirebaseFirestore.instance.collection("fpos").doc(_uid).set({
        'uid': _uid,
        'logoUrl': logoURL!,
        'fpoShortName': _fpoShortNameController.text.trim(),
        'fpoFullName': _fpoFullNameController.text.trim(),
        'regType': _registrationType!.trim(),
        'regNum': _regNumController.text.trim().toUpperCase(),
        'regDate': _regDateController.text.trim(),
        'pan': _panController.text.trim().toUpperCase(),
        'fpoAddress': _addressController.text.trim(),
        'contactNum': int.parse(_contactNumController.text.trim()),
        'email': _emailController.text.trim().toLowerCase(),
        'createdAt': Timestamp.now(),
      }).whenComplete(() async {
        final snackBar = await SnackBar(
          content: Text("Account created successfully"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("You are not able to create account due to $error"),
            );
          },
        );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email';
      } else if (e.code == 'invalid-email') {
        return 'Email address is invalid';
      } else if (_fpoShortNameController.text.isEmpty) {
        return 'Please enter fpo short name';
      } else if (_fpoFullNameController.text.isEmpty) {
        return 'Please enter fpo full name';
      } else if (_registrationType == null) {
        return 'Please select fpo registration type';
      } else if (_regNumController.text.isEmpty) {
        return 'Please enter fpo registration number';
      } else if (_regDateController.text.isEmpty) {
        return 'Please select registration date';
      } else if (_panController.text.isEmpty) {
        return 'Please enter fpo pan number';
      } else if (_addressController.text.isEmpty) {
        return 'Please enter fpo address';
      } else if (_contactNumController.text.isEmpty) {
        return 'Please enter fpo contact number';
      } else if (_emailController.text.isEmpty) {
        return 'Please enter fpo email id';
      } else if (_passwordController.text.isEmpty) {
        return 'Please set password';
      } else if (_confirmPasswordController.text.isEmpty) {
        return 'Please enter confirmed password';
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
      const AlertDialog(
        title: Text("Alert"),
        content: Text("Your account not created."),
      );
      Navigator.canPop(context) ? Navigator.pop(context) : null;
    }
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
        imageFile = File(croppedImage.path);
      });
    }
  }

  @override
  void dispose() {
    _fpoShortNameController.dispose();
    _fpoFullNameController.dispose();
    _regNumController.dispose();
    _regDateController.dispose();
    _panController.dispose();
    _addressController.dispose();
    _contactNumController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: SafeArea(
          child: Form(
            key: _registrationFormKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text(
                      "Create new account",
                      style: boldHeading,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const SizedBox(height: 6),
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
                                      imageFile == null
                                          ? const Icon(
                                              Icons.add_a_photo_outlined,
                                              color: secondaryColor,
                                              size: 40,
                                            )
                                          : Expanded(
                                              child: Image.file(
                                                imageFile!,
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
                                            Text("Camera",
                                                style: regularDarkText)
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
                                            Text("Gallery",
                                                style: regularDarkText)
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
                        const SizedBox(height: 8),
                        CustomFormField(
                          title: "FPO short name",
                          mandatorySymbol: " *",
                          controller: _fpoShortNameController,
                          obscureText: false,
                          hintText: "Enter fpo short name",
                          fillColor: accentColor,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          icon: const Icon(Icons.person_outline),
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'^(?!\s)[a-z A-Z]+$')
                                        .hasMatch(value))
                                ? "Please enter valid name"
                                : null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomFormField(
                          title: "FPO full name",
                          mandatorySymbol: " *",
                          controller: _fpoFullNameController,
                          obscureText: false,
                          hintText: "Enter fpo full name",
                          fillColor: accentColor,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          icon: const Icon(Icons.person_outline),
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'^(?!\s)[a-z A-Z]+$')
                                        .hasMatch(value))
                                ? "Please enter valid name"
                                : null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomAutoCompleteField(
                          title: "Registration type",
                          mandatorySymbol: " *",
                          itemList: _registrationTypes,
                          hintText: "Select registration type",
                          fillColor: accentColor,
                          icon: const Icon(Icons.type_specimen_outlined),
                          dropDownContainerWidth:
                              MediaQuery.of(context).size.width / 1.14,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSelected: (onSelected) {
                            setState(() {
                              _registrationType = onSelected;
                            });
                          },
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'^(?!\s)[a-z A-Z]+$')
                                        .hasMatch(value))
                                ? "Please select any one of these"
                                : null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomFormField(
                          obscureText: false,
                          controller: _regNumController,
                          title: "Registration number",
                          mandatorySymbol: " *",
                          hintText: "Enter registration number",
                          icon: const Icon(Icons.app_registration),
                          fillColor: accentColor,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'^(?!\s)[A-Z 0-9 /]+$')
                                        .hasMatch(value))
                                ? "Please enter valid number"
                                : null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomFormField(
                          obscureText: false,
                          controller: _regDateController,
                          title: "Registration date",
                          mandatorySymbol: " *",
                          icon: const Icon(Icons.calendar_today_outlined),
                          fillColor: accentColor,
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          hintText: "Enter registration date",
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
                                _regDateController.text =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                              });
                            }
                          },
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'^(?!\s)[0-9 -/.]+$')
                                        .hasMatch(value))
                                ? "Invalid date"
                                : null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomFormField(
                          obscureText: false,
                          controller: _panController,
                          title: "PAN",
                          mandatorySymbol: " *",
                          hintText: "Enter pan number",
                          icon: const Icon(Icons.credit_card_rounded),
                          fillColor: accentColor,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          maxLength: 10,
                          counterText: "",
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'^(?!\s)[A-Z 0-9]+$')
                                        .hasMatch(value))
                                ? "Please enter valid number"
                                : null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomFormField(
                          title: "FPO office address",
                          mandatorySymbol: " *",
                          controller: _addressController,
                          obscureText: false,
                          hintText: "Enter fpo office address",
                          fillColor: accentColor,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          icon: const Icon(Icons.location_on_outlined),
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'^(?!\s)[a-z A-Z 0-9 #,./-]+$')
                                        .hasMatch(value))
                                ? "Please enter valid text"
                                : null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomFormField(
                          obscureText: false,
                          controller: _contactNumController,
                          title: "Contact number",
                          mandatorySymbol: " *",
                          hintText: "Enter contact number",
                          icon: const Icon(Icons.phone_android),
                          keyboardType: TextInputType.number,
                          fillColor: accentColor,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          maxLength: 10,
                          counterText: "",
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'^(?!\s)[0-9]+$').hasMatch(value))
                                ? "Please enter 10 digit mobile number"
                                : null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomFormField(
                          obscureText: false,
                          controller: _emailController,
                          title: "FPO email address",
                          mandatorySymbol: " *",
                          hintText: "Enter fpo email address",
                          fillColor: accentColor,
                          icon: const Icon(Icons.email_outlined),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r"^(?!\s)[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value))
                                ? "Please enter valid email"
                                : null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomFormField(
                          obscureText: true,
                          controller: _passwordController,
                          title: "Password",
                          mandatorySymbol: " *",
                          hintText: "Set password",
                          icon: const Icon(Icons.password_outlined),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          fillColor: accentColor,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'^(?!\s)(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
                                        .hasMatch(value))
                                ? "Contains at least one letter, number, special char"
                                : null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomFormField(
                          obscureText: _passwordVisibility,
                          controller: _confirmPasswordController,
                          title: "Confirm password",
                          mandatorySymbol: " *",
                          hintText: "Enter confirm password",
                          icon: const Icon(Icons.password_outlined),
                          suffixIcon: IconButton(
                              color: primaryColor,
                              icon: _passwordVisibility
                                  ? const Icon(Icons.visibility_outlined)
                                  : const Icon(Icons.visibility_off_outlined),
                              onPressed: () {
                                setState(() {
                                  _passwordVisibility = !_passwordVisibility;
                                });
                              }),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          fillColor: accentColor,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          validator: (String? value) {
                            return (value!.isEmpty ||
                                    !RegExp(r'^(?!\s)(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
                                        .hasMatch(value))
                                ? "Contains at least one letter, number, special char"
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: CustomButton(
                      buttonText: "Register",
                      outlineButton: false,
                      onPressed: () {
                        _submitForm();
                        setState(() {
                          _registerFormLoading = true;
                        });
                      },
                      isLoading: _registerFormLoading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: CustomButton(
                      isLoading: _registerFormLoading = false,
                      buttonText: "Back",
                      outlineButton: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
