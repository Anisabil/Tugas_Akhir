import 'dart:convert';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:http/http.dart' as http;

Future<String> initiateMidtransPaymentProcess(Rent rent) async {
  final clientKey = 'SB-Mid-client-FyQWww0JuWijB_iF';
  final auth = 'Basic ' + base64Encode(utf8.encode(clientKey + ':'));

  final response = await http.post(
    Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': auth,
    },
    body: jsonEncode({
      "transaction_details": {
        "order_id": "order-id-${rent.id}-${DateTime.now().millisecondsSinceEpoch}",
        "gross_amount": rent.totalPrice,
      },
      "item_details": [
        {
          "id": rent.packageId,
          "price": rent.totalPrice,
          "quantity": 1,
          "name": rent.theme
        }
      ],
      "enabled_payments": ["bank_transfer"],
    }),
  );

  print('Midtrans response: ${response.body}'); // Debug: Print the response body

  if (response.statusCode == 201 || response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final redirectUrl = responseData['redirect_url'];
    return redirectUrl; // Mengembalikan Redirect URL
  } else {
    print('Failed to create transaction: ${response.body}');
    throw Exception('Failed to create transaction: ${response.body}');
  }
}