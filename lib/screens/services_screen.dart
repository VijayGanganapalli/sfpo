import 'package:sfpo/constants/packages.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text('Services', style: TextStyle(color: accentColor)),
          ),
        ],
      ),
    );
  }
}
