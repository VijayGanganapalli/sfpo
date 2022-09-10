import 'package:sfpo/constants/packages.dart';

class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text('Policies', style: TextStyle(color: accentColor)),
          ),
        ],
      ),
    );
  }
}
