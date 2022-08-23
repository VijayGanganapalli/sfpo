import 'package:sfpo/constants/packages.dart';

Future<void> alertDialogBuilder(BuildContext context, String error) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("Alert"),
        content: Text(error),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
