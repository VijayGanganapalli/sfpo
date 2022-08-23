import 'package:sfpo/constants/packages.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Text controllers
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<String?> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (_emailController.text.isEmpty) {
        return 'Please enter your email id';
      } else if (e.code == 'invalid-email') {
        return 'Email address is invalid';
      } else if (e.code == 'user-not-found') {
        return 'No user found with this email';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submit() async {
    setState(() {
      _loading = true;
    });
    String? _loginAccountFeedback = await _resetPassword();
    if (_loginAccountFeedback != null) {
      alertDialogBuilder(context, _loginAccountFeedback);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Reset password"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter your email and we will send you a password reset link",
                textAlign: TextAlign.center,
                style: regularDarkText,
              ),
              CustomFormField(
                obscureText: false,
                controller: _emailController,
                title: "",
                mandatorySymbol: "",
                hintText: "FPO email id",
                fillColor: accentColor,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: (String? value) {
                  return (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value))
                      ? "Please enter valid email "
                      : null;
                },
              ),
              const SizedBox(height: 24),
              // Reset password button
              CustomButton(
                buttonText: "Reset password",
                outlineButton: false,
                onPressed: _submit,
                isLoading: _loading,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: CustomButton(
                  isLoading: _loading = false,
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
    );
  }
}
