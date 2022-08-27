import 'package:sfpo/constants/packages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loginFormLoading = false;
  bool _passwordVisibility = true;

  // Create a new user account
  Future<String?> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        return 'Email address is invalid.';
      } else if (e.code == 'user-not-found') {
        return 'There is no account with this email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password entered.';
      } else if (_emailController.text.isEmpty) {
        return 'Please enter username.';
      } else if (_passwordController.text.isEmpty) {
        return 'Please enter password.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  //
  void _submitForm() async {
    setState(() {
      _loginFormLoading = true;
    });
    String? _loginAccountFeedback = await _loginAccount();
    if (_loginAccountFeedback != null) {
      alertDialogBuilder(context, _loginAccountFeedback);
      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: loginFormKey,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    CustomFormField(
                      obscureText: false,
                      controller: _emailController,
                      title: "Username",
                      mandatorySymbol: "",
                      hintText: "Email",
                      fillColor: accentColor,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value))
                            ? "Please enter valid email"
                            : null;
                      },
                    ),
                    const SizedBox(height: 8),
                    CustomFormField(
                      obscureText: _passwordVisibility,
                      controller: _passwordController,
                      title: "Password",
                      mandatorySymbol: "",
                      hintText: "Password",
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      fillColor: accentColor,
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: (String? value) {
                        return (value!.isEmpty ||
                                !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
                                    .hasMatch(value))
                            ? "Contains at least one letter, number, special char"
                            : null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            child: const Text(
                              "Forgot password, reset here!",
                              style: linkText,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: CustomButton(
                        buttonText: "Login",
                        outlineButton: false,
                        onPressed: () {
                          _submitForm();
                          setState(() {
                            _loginFormLoading = true;
                          });
                        },
                        isLoading: _loginFormLoading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 32),
                      child: CustomButton(
                        isLoading: _loginFormLoading = false,
                        buttonText: "Create new account",
                        outlineButton: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
