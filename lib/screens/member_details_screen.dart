import 'package:sfpo/constants/packages.dart';
import 'package:sfpo/services/get_members_info.dart';

class MemberDetailsScreen extends StatefulWidget {
  final String memberId;

  const MemberDetailsScreen({Key? key, required this.memberId})
      : super(key: key);

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  String? fullName;
  String? surname;
  String? gender;
  String? maritalStatus;
  String? fatherOrHusbandName;
  int? aadhar;
  int? mobileNumber;
  String? dob;
  double? landHolding;
  String? state;
  String? district;
  String? mandal;
  String? gramaPanchayati;
  String? habitation;
  String? joiningDate;
  int? membership;
  int? shareCapital;

  Future getDataFromFirebase() async {
    var snapshot = Global.membersRef.doc(widget.memberId).get();
    await snapshot.then((docSnapshot) {
      setState(() {
        fullName = docSnapshot.get('fullName');
        surname = docSnapshot.get('surname');
        fatherOrHusbandName = docSnapshot.get('fatherOrHusbandName');
        gender = docSnapshot.get('gender');
        maritalStatus = docSnapshot.get('maritalStatus');
        aadhar = docSnapshot.get('aadhar');
        mobileNumber = docSnapshot.get('mobileNumber');
        dob = docSnapshot.get('dob');
        landHolding = docSnapshot.get('landHolding');
        state = docSnapshot.get('state');
        district = docSnapshot.get('district');
        mandal = docSnapshot.get('mandal');
        gramaPanchayati = docSnapshot.get('gramaPanchayati');
        habitation = docSnapshot.get('habitation');
        joiningDate = docSnapshot.get('joiningDate');
        membership = docSnapshot.get('membership');
        shareCapital = docSnapshot.get('shareCapital');
      });
    });
  }

  getRelationship() => (gender == "Female" && maritalStatus == "Married")
      ? "Husband name"
      : "Father name";

  getMemberData() {
    return FirebaseFirestore.instance
        .collection("fpos")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("members")
        .doc(widget.memberId)
        .snapshots()
        .map((document) => document.get("fullName"));
  }

  @override
  Widget build(BuildContext context) {
    getDataFromFirebase();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Member details"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              print(const GetMembersInfo());
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const CircleAvatar(
                radius: 60,
                backgroundColor: avatarBackgroundColor,
                child: Icon(
                  Icons.person_rounded,
                  size: 80,
                  color: avatarIconColor,
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                dense: true,
                leading: const Text("Full name", style: membersTitle),
                trailing: Text("$fullName $surname", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: Text(getRelationship(), style: membersTitle),
                trailing: Text("$fatherOrHusbandName", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("Gender", style: membersTitle),
                trailing: Text("$gender", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("Marital status", style: membersTitle),
                trailing: Text("$maritalStatus", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("Aadhar", style: membersTitle),
                trailing: Text("$aadhar", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("Mobile", style: membersTitle),
                trailing: Text("$mobileNumber", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("Date of birth", style: membersTitle),
                trailing: Text("$dob", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("Land holding", style: membersTitle),
                trailing: Text("$landHolding", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("State", style: membersTitle),
                trailing: Text("$state", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("District", style: membersTitle),
                trailing: Text("$district", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("Mandal", style: membersTitle),
                trailing: Text("$mandal", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("Grama panchayathi", style: membersTitle),
                trailing: Text("$gramaPanchayati", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("Habitation", style: membersTitle),
                trailing: Text("$habitation", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("Joining date", style: membersTitle),
                trailing: Text("$joiningDate", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("Membership", style: membersTitle),
                trailing: Text("$membership", style: membersText),
              ),
              ListTile(
                dense: true,
                leading: const Text("Share capital", style: membersTitle),
                trailing: Text("$shareCapital", style: membersText),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
