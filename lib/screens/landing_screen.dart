import 'package:sfpo/constants/packages.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // if snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
        // if connection is done then firebase app initialized
        if (snapshot.connectionState == ConnectionState.done) {
          // StreamBuilder can check the login state live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              // if snapshot has error
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }
              // connection state active - user login check inside the if statement
              if (streamSnapshot.connectionState == ConnectionState.active) {
                // get the user
                User? _user = streamSnapshot.data as User?;
                // check the user is null or not
                if (_user == null) {
                  return const LoginScreen();
                } else {
                  return const DashboardScreen();
                }
              }
              // Checking the auth state - loading
              return const Scaffold(
                body: Center(
                  child: Text(
                    "Checking authentication...",
                    style: regularHeading,
                  ),
                ),
              );
            },
          );
        }
        // connecting to firebase - loading
        return const Scaffold(
          body: Center(
            child: Text(
              "Initialing...",
              style: regularHeading,
            ),
          ),
        );
      },
    );
  }
}
