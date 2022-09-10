import 'package:sfpo/constants/packages.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text('Weather', style: TextStyle(color: accentColor)),
          ),
        ],
      ),
    );
  }
}
