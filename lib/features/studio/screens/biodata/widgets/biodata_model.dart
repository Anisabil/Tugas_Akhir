import 'package:cloud_firestore/cloud_firestore.dart';

class Biodata {
  final String userId;
  final String rentId;
  final String priaNama;
  final String nomorTeleponPria;
  final String akunInstagramPria;
  final String alamatPria;
  final String wanitaNama;
  final String nomorTeleponWanita;
  final String akunInstagramWanita;
  final String alamatWanita;
  final Timestamp createdAt;

  Biodata({
    required this.userId,
    required this.rentId,
    required this.priaNama,
    required this.nomorTeleponPria,
    required this.akunInstagramPria,
    required this.alamatPria,
    required this.wanitaNama,
    required this.nomorTeleponWanita,
    required this.akunInstagramWanita,
    required this.alamatWanita,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rentId': rentId,
      'priaNama': priaNama,
      'nomorTeleponPria': nomorTeleponPria,
      'akunInstagramPria': akunInstagramPria,
      'alamatPria': alamatPria,
      'wanitaNama': wanitaNama,
      'nomorTeleponWanita': nomorTeleponWanita,
      'akunInstagramWanita': akunInstagramWanita,
      'alamatWanita': alamatWanita,
      'createdAt': createdAt,
    };
  }

  factory Biodata.fromMap(Map<String, dynamic> map) {
    return Biodata(
      userId: map['userId'],
      rentId: map['rentId'],
      priaNama: map['priaNama'],
      nomorTeleponPria: map['nomorTeleponPria'],
      akunInstagramPria: map['akunInstagramPria'],
      alamatPria: map['alamatPria'],
      wanitaNama: map['wanitaNama'],
      nomorTeleponWanita: map['nomorTeleponWanita'],
      akunInstagramWanita: map['akunInstagramWanita'],
      alamatWanita: map['alamatWanita'],
      createdAt: map['createdAt'],
    );
  }
}
