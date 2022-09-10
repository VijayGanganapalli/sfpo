import 'package:sfpo/constants/packages.dart';

class GovernanceScreen extends StatelessWidget {
  const GovernanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.medium(
            title: Text('Governance', style: TextStyle(color: accentColor)),
          ),
        ],
      ),
    );
  }
}
