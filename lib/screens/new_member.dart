import 'package:sfpo/constants/packages.dart';

class NewMember extends StatefulWidget {
  const NewMember({Key? key}) : super(key: key);

  @override
  State<NewMember> createState() => _NewMemberState();
}

class _NewMemberState extends State<NewMember> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? fullName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                onChanged: (value) {
                  fullName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter full name";
                  }
                  return null;
                },
              ),
              TextFormField(),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {}
                  print("You entered: $fullName");
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
