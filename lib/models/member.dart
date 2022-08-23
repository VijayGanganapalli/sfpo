import 'package:sfpo/constants/packages.dart';

class Member {
  String? fullName;
  String? surname;
  String? gender;
  String? maritalStatus;
  String? maritalTitle;
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

  Member({
    this.fullName,
    this.surname,
    this.gender,
    this.maritalStatus,
    this.maritalTitle,
    this.fatherOrHusbandName,
    this.aadhar,
    this.mobileNumber,
    this.dob,
    this.landHolding,
    this.state,
    this.district,
    this.mandal,
    this.gramaPanchayati,
    this.habitation,
    this.joiningDate,
    this.membership,
    this.shareCapital,
  });

  Future<void> addMember() {
    final members = FirebaseFirestore.instance.collection('members');
    return members.add({
      'fullName': fullName,
      'surname': surname,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'maritalTitle': maritalTitle,
      'fatherOrHusbandName': fatherOrHusbandName,
      'aadhar': aadhar,
      'mobileNumber': mobileNumber,
      'dob': dob,
      'landHolding': landHolding,
      'state': state,
      'district': district,
      'mandal': mandal,
      'gramaPanchayati': gramaPanchayati,
      'habitation': habitation,
      'joiningDate': joiningDate,
      'membership': membership,
      'shareCapital': shareCapital,
    });
  }
}
