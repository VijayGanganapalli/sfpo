import 'package:sfpo/constants/packages.dart';

class CustomMembersCard extends StatelessWidget {
  final String? memImageUrl;
  final String? fullName;
  final String? surname;
  final Function()? onTap;
  final bool? isProfileImageLoaded;
  final String? fatherOrHusbandName;
  final bool? isMarried;
  final String? revenueVillage;
  final String? habitaion;
  final num? membership;
  final num? shareCapital;
  final String? gender;
  final String? maritalTitle;

  CustomMembersCard({
    Key? key,
    this.onTap,
    this.fullName,
    this.surname,
    this.isProfileImageLoaded,
    this.fatherOrHusbandName,
    this.revenueVillage,
    this.habitaion,
    this.membership,
    this.shareCapital,
    this.isMarried,
    this.gender,
    this.maritalTitle,
    this.memImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        margin: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: accentColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: avatarBackgroundColor,
                  radius: 30.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network("$memImageUrl", fit: BoxFit.contain),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$fullName $surname",
                    style: boldMembersTitle,
                  ),
                  Text(
                    "$maritalTitle $fatherOrHusbandName",
                    style: regularMembersText,
                  ),
                  Text(
                    "$revenueVillage",
                    style: regularMembersText,
                  ),
                  Text(
                    "$habitaion",
                    style: regularMembersText,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("M: $membership"),
                    Text("SC: $shareCapital"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
