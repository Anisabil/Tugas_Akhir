import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:fvapp/features/studio/screens/biodata/widgets/biodata_controller.dart';
import 'package:fvapp/features/studio/screens/biodata/widgets/biodata_model.dart';
import 'package:iconsax/iconsax.dart';

class BiodataScreen extends StatefulWidget {
  final String? biodataId; // Tambahkan parameter opsional biodataId
  final String userId;
  final String rentId;

  const BiodataScreen({
    Key? key,
    this.biodataId,
    required this.userId,
    required this.rentId,
  }) : super(key: key);

  @override
  _BiodataScreenState createState() => _BiodataScreenState();
}

class _BiodataScreenState extends State<BiodataScreen> {
  final TextEditingController _priaNamaController = TextEditingController();
  final TextEditingController _nomorTeleponPriaController =
      TextEditingController();
  final TextEditingController _akunInstagramPriaController =
      TextEditingController();
  final TextEditingController _alamatPriaController = TextEditingController();
  final TextEditingController _wanitaNamaController = TextEditingController();
  final TextEditingController _nomorTeleponWanitaController =
      TextEditingController();
  final TextEditingController _akunInstagramWanitaController =
      TextEditingController();
  final TextEditingController _alamatWanitaController = TextEditingController();

  final BiodataController _biodataController = Get.put(BiodataController());

  @override
  void initState() {
    super.initState();
    if (widget.biodataId != null) {
      _loadExistingBiodata();
    }
  }

  void _loadExistingBiodata() async {
    try {
      await _biodataController.loadBiodata(widget.biodataId!);
      Biodata? existingBiodata = _biodataController.biodata.value;
      if (existingBiodata != null) {
        _priaNamaController.text = existingBiodata.priaNama ?? '';
        _nomorTeleponPriaController.text =
            existingBiodata.nomorTeleponPria ?? '';
        _akunInstagramPriaController.text =
            existingBiodata.akunInstagramPria ?? '';
        _alamatPriaController.text = existingBiodata.alamatPria ?? '';

        _wanitaNamaController.text = existingBiodata.wanitaNama ?? '';
        _nomorTeleponWanitaController.text =
            existingBiodata.nomorTeleponWanita ?? '';
        _akunInstagramWanitaController.text =
            existingBiodata.akunInstagramWanita ?? '';
        _alamatWanitaController.text = existingBiodata.alamatWanita ?? '';
      } else {
        print('No existing biodata found');
      }
    } catch (e) {
      print("Error loading biodata: $e");
    }
  }

  void _saveBiodata() async {
    String userId = widget.userId;
    String rentId = widget.rentId;

    Biodata newBiodata = Biodata(
      userId: userId,
      rentId: rentId,
      priaNama: _priaNamaController.text.trim(),
      nomorTeleponPria: _nomorTeleponPriaController.text.trim(),
      akunInstagramPria: _akunInstagramPriaController.text.trim(),
      alamatPria: _alamatPriaController.text.trim(),
      wanitaNama: _wanitaNamaController.text.trim(),
      nomorTeleponWanita: _nomorTeleponWanitaController.text.trim(),
      akunInstagramWanita: _akunInstagramWanitaController.text.trim(),
      alamatWanita: _alamatWanitaController.text.trim(),
      createdAt: Timestamp.now(),
    );

    try {
      if (widget.biodataId != null) {
        await _biodataController.updateBiodata(
            widget.biodataId!, newBiodata, userId, rentId);
      } else {
        await _biodataController.saveBiodata(newBiodata, userId, rentId);
      }
      FVLoaders.successSnackBar(
          title: 'Berhasil!', message: 'Biodata pasangan berhasil ditambahkan');
      Navigator.pop(context);
    } catch (e) {
      FVLoaders.errorSnackBar(
          title: 'Gagal!', message: 'Biodata gagal disimpan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biodata Pasangan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Biodata Pria',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priaNamaController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.user),
                labelText: 'Nama Pria',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomorTeleponPriaController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.mobile),
                labelText: 'Nomor Telepon Pria',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _akunInstagramPriaController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.instagram),
                labelText: 'Akun Instagram Pria',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _alamatPriaController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.building),
                labelText: 'Alamat Pria',
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Biodata Wanita',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _wanitaNamaController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.user),
                labelText: 'Nama Wanita',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomorTeleponWanitaController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.mobile),
                labelText: 'Nomor Telepon Wanita',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _akunInstagramWanitaController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.instagram),
                labelText: 'Akun Instagram Wanita',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _alamatWanitaController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.building),
                labelText: 'Alamat Wanita',
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _saveBiodata,
                child: Text(widget.biodataId != null
                    ? 'Simpan Perubahan'
                    : 'Simpan Biodata'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
