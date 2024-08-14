import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/features/studio/screens/biodata/widgets/biodata_controller.dart';
import 'package:fvapp/features/studio/screens/biodata/widgets/biodata_model.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CoupleDataScreen extends StatefulWidget {
  final String? coupleDataId; // Optional parameter for coupleDataId
  final String userId;
  final String rentId;

  const CoupleDataScreen({
    Key? key,
    this.coupleDataId,
    required this.userId,
    required this.rentId,
  }) : super(key: key);

  @override
  _CoupleDataScreenState createState() => _CoupleDataScreenState();
}

class _CoupleDataScreenState extends State<CoupleDataScreen> {
  final TextEditingController _groomNameController = TextEditingController();
  final TextEditingController _groomPhoneController = TextEditingController();
  final TextEditingController _groomInstagramController = TextEditingController();
  final TextEditingController _groomAddressController = TextEditingController();
  final TextEditingController _brideNameController = TextEditingController();
  final TextEditingController _bridePhoneController = TextEditingController();
  final TextEditingController _brideInstagramController = TextEditingController();
  final TextEditingController _brideAddressController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();

  final CoupleDataController _coupleDataController = Get.put(CoupleDataController());

  @override
  void initState() {
    super.initState();
    if (widget.coupleDataId != null) {
      _loadExistingCoupleData();
    }
  }

  void _loadExistingCoupleData() async {
    try {
      await _coupleDataController.loadCoupleData(widget.coupleDataId!);
      CoupleData? existingCoupleData = _coupleDataController.coupleData.value;
      if (existingCoupleData != null) {
        _groomNameController.text = existingCoupleData.groomName ?? '';
        _groomPhoneController.text = existingCoupleData.groomPhone ?? '';
        _groomInstagramController.text = existingCoupleData.groomInstagram ?? '';
        _groomAddressController.text = existingCoupleData.groomAddress ?? '';
        _brideNameController.text = existingCoupleData.brideName ?? '';
        _bridePhoneController.text = existingCoupleData.bridePhone ?? '';
        _brideInstagramController.text = existingCoupleData.brideInstagram ?? '';
        _brideAddressController.text = existingCoupleData.brideAddress ?? '';
        _locationController.text = existingCoupleData.location ?? '';
        _eventDescriptionController.text = existingCoupleData.eventDescription ?? '';
      } else {
        print('Data pasangan tidak ditemukan');
      }
    } catch (e) {
      print("Error memuat data pasangan: $e");
    }
  }

  void _saveCoupleData() async {
    String userId = widget.userId;
    String rentId = widget.rentId;

    CoupleData newCoupleData = CoupleData(
      userId: userId,
      rentId: rentId,
      groomName: _groomNameController.text.trim(),
      groomPhone: _groomPhoneController.text.trim(),
      groomInstagram: _groomInstagramController.text.trim(),
      groomAddress: _groomAddressController.text.trim(),
      brideName: _brideNameController.text.trim(),
      bridePhone: _bridePhoneController.text.trim(),
      brideInstagram: _brideInstagramController.text.trim(),
      brideAddress: _brideAddressController.text.trim(),
      location: _locationController.text.trim(),
      eventDescription: _eventDescriptionController.text.trim(),
      createdAt: Timestamp.now(),
    );

    try {
      if (widget.coupleDataId != null) {
        await _coupleDataController.updateCoupleData(widget.coupleDataId!, newCoupleData, userId, rentId);
      } else {
        await _coupleDataController.saveCoupleData(newCoupleData, userId, rentId);
      }
      FVLoaders.successSnackBar(title: 'Berhasil!', message: 'Data pasangan berhasil disimpan');
      Navigator.pop(context);
    } catch (e) {
      FVLoaders.errorSnackBar(title: 'Gagal!', message: 'Gagal menyimpan data pasangan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pasangan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Pria',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _groomNameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.user),
                labelText: 'Nama Pria',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _groomPhoneController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.mobile),
                labelText: 'Telepon Pria',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _groomInstagramController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.instagram),
                labelText: 'Instagram Pria',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _groomAddressController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.building),
                labelText: 'Alamat Pria',
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Detail Wanita',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _brideNameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.user),
                labelText: 'Nama Wanita',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bridePhoneController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.mobile),
                labelText: 'Telepon Wanita',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _brideInstagramController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.instagram),
                labelText: 'Instagram Wanita',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _brideAddressController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.building),
                labelText: 'Alamat Wanita',
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.map),
                labelText: 'Lokasi Acara',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _eventDescriptionController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.text),
                labelText: 'Deskripsi Acara',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveCoupleData,
              child: Text(widget.coupleDataId != null ? 'Perbarui' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
