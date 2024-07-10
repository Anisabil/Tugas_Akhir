import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RentController extends GetxController {
  late CollectionReference<Map<String, dynamic>> _rentsCollection;

  @override
  void onInit() {
    super.onInit();
    _rentsCollection = FirebaseFirestore.instance.collection('rents');
    initializeRentsCollection();
  }

  Future<void> initializeRentsCollection() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _rentsCollection = FirebaseFirestore.instance
            .collection('rents')
            .doc(user.uid)
            .collection('userRents');
      } else {
        // Wait for user authentication before initializing _rentsCollection
        User? currentUser = await FirebaseAuth.instance.authStateChanges().firstWhere((user) => user != null);
        if (currentUser != null) {
          _rentsCollection = FirebaseFirestore.instance
              .collection('rents')
              .doc(currentUser.uid)
              .collection('userRents');
        } else {
          throw Exception('User not authenticated');
        }
      }
    } catch (e) {
      throw Exception('Failed to initialize rents collection: $e');
    }
  }

  Future<void> addRent(Rent rent) async {
    try {
      await initializeRentsCollection(); // Pastikan _rentsCollection sudah diinisialisasi

      if (_rentsCollection != null) {
        Uint8List qrCodeData = await generateQRCodeForPayment(rent); // Generate QR code
        rent.qrCodeData = qrCodeData; // Save QR code data to the rent object
        await _rentsCollection.add(rent.toMap());
        print('Rent added successfully');
      } else {
        throw Exception('Rents collection is not initialized');
      }
    } catch (e) {
      throw Exception('Failed to add rent: $e');
    }
  }

  Future<List<Rent>> getRentsByUserId(String userId) async {
    try {
      final querySnapshot =
          await _rentsCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isEmpty) {
        return []; // Return an empty list if no data found
      }

      return querySnapshot.docs.map((doc) => Rent.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to load rents: $e');
    }
  }

  Future<List<Rent>> getRents() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _rentsCollection.get();
      print('Number of rents: ${snapshot.size}');
      snapshot.docs.forEach((doc) {
        print('Rent Data: ${doc.data()}');
      });
      return snapshot.docs.map((doc) => Rent.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to load rents: $e');
    }
  }

  Future<Rent?> getRentById(String rentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _rentsCollection.doc(rentId).get();
      if (doc.exists) {
        return Rent.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load rent: $e');
    }
  }

  Future<void> updateRentStatus(String rentId, String newStatus) async {
    try {
      await _rentsCollection.doc(rentId).update({'status': newStatus});
    } catch (e) {
      throw Exception('Failed to update rent status: $e');
    }
  }

  final isLoading = RxBool(true);
  final rent = Rxn<Rent>();

  void loadRentDetail(String rentId) async {
    try {
      isLoading.value = true;
      rent.value = await getRentById(rentId);
    } catch (e) {
      print('Failed to load rent: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Uint8List> generateQRCodeForPayment(Rent rent) async {
    final String qrData = "Total Pembayaran: ${rent.totalPrice}\n" +
                          "Down Payment: ${rent.downPayment}\n" +
                          "Sisa Pembayaran: ${rent.remainingPayment}";

    final qrCode = QrPainter(
      data: qrData,
      version: QrVersions.auto,
      gapless: false,
    );

    final picRecorder = ui.PictureRecorder();
    final canvas = Canvas(picRecorder);
    final size = const Size(200, 200);

    final rect = Offset.zero & size;
    final paint = Paint()..color = FVColors.white;

    canvas.drawRect(rect, paint);
    qrCode.paint(canvas, size);

    final img = await picRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<void> deleteRent(String rentId) async {
    try {
      await _rentsCollection.doc(rentId).delete();
    } catch (e) {
      throw Exception('Failed to delete rent: $e');
    }
  }
}
