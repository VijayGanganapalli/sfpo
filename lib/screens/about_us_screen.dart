import 'package:sfpo/constants/packages.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text('About us', style: TextStyle(color: accentColor)),
          ),
        ],
      ),
    );
  }
}
