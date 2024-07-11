import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';

class InvoicePdf {
  Future<Uint8List> generateInvoicePDF(Rent rent) async {
    final pdf = pw.Document();
    final image = (await rootBundle.load(FVImages.mylogo)).buffer.asUint8List();

    // Get admin and client data from Firestore
    final adminData = await _getAdminData();
    final clientData = await _getClientData(rent.userId);

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                color: PdfColors.black, // Set background color to black
                padding: pw.EdgeInsets.symmetric(vertical: 20, horizontal: 40), // Padding for content
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Image(
                          pw.MemoryImage(image),
                          width: 160, // Ukuran logo diperbesar
                          height: 160,
                        ),
                        pw.SizedBox(width: 10),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 113,
                              height: 2,
                              color: PdfColors.orange300,
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                          'INVOICE',
                          style: pw.TextStyle(
                            color: PdfColors.orange300,
                            fontSize: 28,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Container(
                          width: 113,
                          height: 2,
                          color: PdfColors.orange300,
                        ),
                            pw.SizedBox(height: 10),
                            _buildContactInfo(adminData),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 15),
                    _buildClientInfo(clientData),
                    pw.SizedBox(height: 15),
                    _buildRentTable(rent),
                    pw.SizedBox(height: 15), // Added space below the table
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBankDetails(),
                        _buildFooter(rent),
                      ],
                    ),
                    pw.SizedBox(height: 80),
                    _buildSignature(),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF file
    final output = await getExternalStorageDirectory();
    final fileName = "${rent.id}_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final file = File("${output!.path}/$fileName");
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file
    OpenFile.open("${output.path}/$fileName");

    // Return the PDF as Uint8List
    return await file.readAsBytes();
  }

  pw.Widget _buildContactInfo(Map<String, dynamic> adminData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('No. Telp: ${adminData['phoneNumber']}', style: pw.TextStyle(color: PdfColors.orange300)),
        pw.Text('Instagram: @kr.visualstory', style: pw.TextStyle(color: PdfColors.orange300)),
        pw.Text('YouTube: kr.visualstory', style: pw.TextStyle(color: PdfColors.orange300)),
        pw.Text('Jl. Teknik Sipil No.1 Komplek USB YPKP', style: pw.TextStyle(color: PdfColors.orange300)),
        pw.Text('RT 06/02 Kelurahan Padasuka Kecamatan', style: pw.TextStyle(color: PdfColors.orange300)),
        pw.Text('Cimenyan Kabupaten Bandung 40191', style: pw.TextStyle(color: PdfColors.orange300)),
      ],
    );
  }

  pw.Widget _buildClientInfo(Map<String, dynamic> clientData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Nama Client: ${clientData['userName']}', style: pw.TextStyle(color: PdfColors.orange300)),
        pw.Text('Email: ${clientData['email']}', style: pw.TextStyle(color: PdfColors.orange300)),
        pw.Text('No. Telp: ${clientData['phoneNumber']}', style: pw.TextStyle(color: PdfColors.orange300)),
      ],
    );
  }

  pw.Widget _buildRentTable(Rent rent) {
    final data = [
      ['Tanggal', 'Description', 'Price', 'Total'],
      [
        DateFormat('dd MMMM yyyy').format(rent.date),
        'Paket: ${rent.packageName},\n' +
            'Tema: ${rent.theme},\n' +
            'Metode Pembayaran: ${rent.paymentMethod},\n' +
            'Deskripsi: ${rent.description}',
        rent.totalPrice.toString(),
        '', // Empty cell for Total column
      ],
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.orange300),
          columnWidths: {
            0: pw.FixedColumnWidth(80), // Tanggal
            1: pw.FlexColumnWidth(),   // Description
            2: pw.FixedColumnWidth(80), // Price
            3: pw.FixedColumnWidth(80), // Total
          },
          children: data.map((row) {
            return pw.TableRow(
              children: row.asMap().entries.map((entry) {
                String cell = entry.value;

                return pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text(
                    cell,
                    style: pw.TextStyle(color: PdfColors.orange300),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ],
    );
  }

  pw.Widget _buildBankDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Rekening BCA', style: pw.TextStyle(color: PdfColors.orange300)),
        pw.Text('4372512036', style: pw.TextStyle(color: PdfColors.orange300, fontSize: 15)),
        pw.Text('A/N HAMDAN RAMDANI', style: pw.TextStyle(color: PdfColors.orange300)),
      ],
    );
  }

  pw.Widget _buildFooter(Rent rent) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('SUB TOTAL:               ${rent.totalPrice.toString()}', style: pw.TextStyle(color: PdfColors.orange300, fontSize: 10)),
        pw.Text('DOWN PAYMENT:       ${rent.downPayment.toString()}', style: pw.TextStyle(color: PdfColors.orange300, fontSize: 10)),
        pw.Text('SISA PEMBAYARAN: ${rent.remainingPayment.toString()}', style: pw.TextStyle(color: PdfColors.orange300, fontSize: 10)),
      ],
    );
  }

  pw.Widget _buildSignature() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Hormat Kami,', style: pw.TextStyle(color: PdfColors.orange300)),
            pw.SizedBox(height: 30),
            pw.Text('Kr.Visualstory', style: pw.TextStyle(color: PdfColors.orange300)),
          ],
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> _getAdminData() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('role', isEqualTo: 'admin')
        .get();
    return querySnapshot.docs.first.data();
  }

  Future<Map<String, dynamic>> _getClientData(String userId) async {
    final snapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    return snapshot.data()!;
  }
}
