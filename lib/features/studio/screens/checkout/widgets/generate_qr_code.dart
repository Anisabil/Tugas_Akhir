import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future<void> sendQRCodeToClient(String clientEmail, Uint8List qrCodeData) async {
  try {
    // Simpan QR code sebagai file sementara
    final Directory tempDir = await getTemporaryDirectory();
    final File qrCodeFile = File('${tempDir.path}/qr_code.png');
    await qrCodeFile.writeAsBytes(qrCodeData);

    // SMTP server configuration
    String username = 'anisaputriani2603@gmail.com'; // Ganti dengan email Anda
    String password = 'anisaputri2602'; // Ganti dengan password email Anda

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'KR Visual Story') // Ganti dengan nama Anda
      ..recipients.add(clientEmail)
      ..subject = 'QR Code Pembayaran'
      ..text = 'Terima kasih telah memesan. Berikut adalah QR Code pembayaran Anda.'
      ..attachments.add(FileAttachment(qrCodeFile));

    await send(message, smtpServer);
  } catch (error) {
    print('Failed to send email: $error');
    throw Exception('Failed to send email');
  }
}

Future<Uint8List> generateQRCode(String data) async {
  // Buat widget QrImage
  final qrCode = QrPainter(
    data: data,
    version: QrVersions.auto,
    gapless: false,
  );

  // Buat PictureRecorder untuk menangkap lukisan
  final picRecorder = ui.PictureRecorder();
  final canvas = Canvas(picRecorder);
  final size = const Size(200, 200);

  // Definisikan rectangle dan paint
  final rect = Offset.zero & size;
  final paint = Paint()..color = Colors.white;

  // Isi kanvas dengan background putih
  canvas.drawRect(rect, paint);

  // Lukis QR code di kanvas
  qrCode.paint(canvas, size);

  // Konversi kanvas ke gambar
  final img = await picRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt());

  // Konversi gambar ke byte data
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

  // Kembalikan byte data sebagai Uint8List
  return byteData!.buffer.asUint8List();
}

// Contoh penggunaan fungsi-fungsi di atas
void sendEmailWithQRCode() async {
  try {
    final qrCodeData = await generateQRCode('Contoh Data QR Code');
    await sendQRCodeToClient('client@example.com', qrCodeData);
    print('Email berhasil dikirim.');
  } catch (e) {
    print('Gagal mengirim email: $e');
  }
}
