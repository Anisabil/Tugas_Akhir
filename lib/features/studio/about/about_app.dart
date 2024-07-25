import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/package_controller.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/features/personalization/controllers/user_controller.dart';
import 'package:fvapp/features/personalization/models/user_model.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart'; // Pastikan package iconsax sudah ditambahkan pada pubspec.yaml

class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController _userController = Get.find();
    final PackageController _packageController = Get.find();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text("KR Visual Story"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profil Admin
            FutureBuilder<UserModel?>(
              future: _userController.fetchAdmin(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data != null) {
                  UserModel admin = snapshot.data!;
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(admin.profilePicture),
                      ),
                      SizedBox(height: 10),
                      Text(
                        admin.fullName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(admin.role),
                      SizedBox(height: 20),
                      // Tambahan informasi kontak admin
                      CustomListTile(
                        icon: Iconsax.mobile,
                        title: 'Hubungi: ${admin.phoneNumber}',
                      ),
                      CustomListTile(
                        icon: Icons.email,
                        title: 'Email: ${admin.email}',
                      ),
                      CustomListTile(
                        icon: Iconsax.instagram,
                        title: 'Instagram: ${admin.instagramName}',
                      ),
                    ],
                  );
                } else {
                  return Text('Data admin tidak ditemukan');
                }
              },
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Text(
                    'KR Visual Story merupakan usaha yang menerima jasa Fotografi dan Videografi untuk kebutuhan Wedding & Prewedding.',
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 35),
            // Galeri Gambar Paket
            SizedBox(
              height: 180,
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Package package = _packageController.packages[index];
                  return SizedBox(
                    width: 160,
                    child: Card(
                      shadowColor: Colors.black12,
                      child: Image.network(
                        package.imageUrls.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 5),
                itemCount: _packageController.packages.length,
              ),
            ),
            SizedBox(height: 35),
            // Container untuk tahapan sewa
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tahapan Sewa Jasa:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.0),
                  _buildRentSteps(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRentSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRentStep('Pilih paket yang diinginkan.'),
        _buildRentStep('Masuk ke detail paketnya.'),
        _buildRentStep('Klik "Sewa", lalu isi 3 form bertahap.'),
        _buildRentStep('Periksa pesanan Anda.'),
        _buildRentStep('Klik "Lanjutkan Pembayaran".'),
        _buildRentStep('Menuju ke halaman pesanan berhasil dibuat.'),
        _buildRentStep('Cek kode QR di detail paket untuk melakukan pembayaran dengan transfer.'),
        _buildRentStep('Konfirmasi kepada admin bahwa sudah melakukan pembayaran dan berdiskusi tentang acara.'),
      ],
    );
  }

  Widget _buildRentStep(String stepText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        stepText,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;

  CustomListTile({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
