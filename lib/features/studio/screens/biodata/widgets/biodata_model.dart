import 'package:cloud_firestore/cloud_firestore.dart';

class CoupleData {
  final String userId;
  final String rentId;
  final String groomName;
  final String groomPhone;
  final String groomInstagram;
  final String groomAddress;
  final String brideName;
  final String bridePhone;
  final String brideInstagram;
  final String brideAddress;
  final String location;
  final String eventDescription;
  final Timestamp createdAt;

  CoupleData({
    required this.userId,
    required this.rentId,
    required this.groomName,
    required this.groomPhone,
    required this.groomInstagram,
    required this.groomAddress,
    required this.brideName,
    required this.bridePhone,
    required this.brideInstagram,
    required this.brideAddress,
    required this.location,
    required this.eventDescription,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rentId': rentId,
      'groomName': groomName,
      'groomPhone': groomPhone,
      'groomInstagram': groomInstagram,
      'groomAddress': groomAddress,
      'brideName': brideName,
      'bridePhone': bridePhone,
      'brideInstagram': brideInstagram,
      'brideAddress': brideAddress,
      'location': location,
      'eventDescription': eventDescription,
      'createdAt': createdAt,
    };
  }

  factory CoupleData.fromMap(Map<String, dynamic> map) {
    return CoupleData(
      userId: map['userId'],
      rentId: map['rentId'],
      groomName: map['groomName'],
      groomPhone: map['groomPhone'],
      groomInstagram: map['groomInstagram'],
      groomAddress: map['groomAddress'],
      brideName: map['brideName'],
      bridePhone: map['bridePhone'],
      brideInstagram: map['brideInstagram'],
      brideAddress: map['brideAddress'],
      location: map['location'],
      eventDescription: map['eventDescription'],
      createdAt: map['createdAt'],
    );
  }
}
