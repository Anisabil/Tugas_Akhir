import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePdf {
  Future<Uint8List> generateInvoicePDF() async {
    final pdf = pw.Document();
    List<pw.Widget> widgets = [];
    final image = (await rootBundle.load(FVImages.mylogo)).buffer.asUint8List();

    final logoArea = pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Logo
        pw.Image(
          pw.MemoryImage(image),
          width: 100,
          height: 100,
        ),
        pw.Padding(
          padding: pw.EdgeInsets.only(left: 10.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Invoice',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.only(left: 10.0, top: 10.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '0818 0420 2541',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
    final gap30 = pw.SizedBox(height: 30);
    final balanceArea =
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Expanded(
        child: pw.Container(
          padding: pw.EdgeInsets.all(10.0),
            height: 70.0,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColor.fromHex('#FFD700')),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Nama Client',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#FFD700'),
                    fontSize: 10.0,
                  )
                ),
                pw.Text('Anisa & Sabil',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#FFD700'),
                    fontWeight: pw.FontWeight.bold,
                  )
                )
              ]
            )
          )
        ),
      ]
    );
    widgets.add(logoArea);
    widgets.add(gap30);
    widgets.add(balanceArea);
    widgets.add(gap30);
    widgets.add(table());

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a3,
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Regular.ttf')),
          bold: pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Bold.ttf')),
          italic: pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Italic.ttf')),
        ),
        build: (pw.Context context) {
          return [
          pw.Container(
            color: PdfColors.black, // Warna latar belakang halaman jadi hitam
            padding: pw.EdgeInsets.all(32.0),
            child: pw.Column(children: widgets),
          ),
        ];
        }));
    return pdf.save();
  }

  pw.Table table() {
    List<pw.TableRow> rows = [];

    for (int i = 0; i < 4; i++) {
      rows.add(
        pw.TableRow(
          children: <pw.Widget>[
          pw.Padding(
            padding: pw.EdgeInsets.all(10.0),
            child: pw.Text('2024-5-26',
                textAlign: pw.TextAlign.left,
                style: pw.TextStyle(fontSize: 10.0))),
          pw.Padding(
            padding: pw.EdgeInsets.all(10.0),
            child: pw.Text('Prewedding Golden Package',
                textAlign: pw.TextAlign.left,
                style: pw.TextStyle(fontSize: 10.0))),
          pw.Padding(
            padding: pw.EdgeInsets.all(10.0),
            child: pw.Text('2.450.000',
                textAlign: pw.TextAlign.left,
                style: pw.TextStyle(fontSize: 10.0))),
          pw.Padding(
            padding: pw.EdgeInsets.all(10.0),
            child: pw.Text('2.450.000',
                textAlign: pw.TextAlign.left,
                style: pw.TextStyle(fontSize: 10.0))),
      ]));
    }
    return pw.Table(
        border: pw.TableBorder.all(color: PdfColor.fromHex('#FFD700')),
        columnWidths: const <int, pw.TableColumnWidth>{
          0: pw.FixedColumnWidth(50),
          1: pw.FixedColumnWidth(150),
          2: pw.FixedColumnWidth(50),
          6: pw.FixedColumnWidth(50),
        },
        children: <pw.TableRow>[
          pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColor.fromHex('#FFD700')),
              children: <pw.Widget>[
                pw.Padding(
                    padding: pw.EdgeInsets.all(10.0),
                    child: pw.Text('Tanggal',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          fontSize: 10.0,
                          color: PdfColor.fromHex('#FFD700'),
                          fontWeight: pw.FontWeight.bold,
                        ))),
                pw.Padding(
                    padding: pw.EdgeInsets.all(10.0),
                    child: pw.Text('Deskripsi',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          fontSize: 10.0,
                          color: PdfColor.fromHex('#FFD700'),
                          fontWeight: pw.FontWeight.bold,
                        ))),
                pw.Padding(
                    padding: pw.EdgeInsets.all(10.0),
                    child: pw.Text('Harga',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          fontSize: 10.0,
                          color: PdfColor.fromHex('#FFD700'),
                          fontWeight: pw.FontWeight.bold,
                        ))),
                pw.Padding(
                    padding: pw.EdgeInsets.all(10.0),
                    child: pw.Text('Total',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          fontSize: 10.0,
                          color: PdfColor.fromHex('#FFD700'),
                          fontWeight: pw.FontWeight.bold,
                        )))
              ]),
            ...rows
        ]
      );
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFile.open(filePath);
  }
}
