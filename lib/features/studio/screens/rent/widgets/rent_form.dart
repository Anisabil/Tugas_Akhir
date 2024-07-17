import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/features/studio/screens/checkout/checkout.dart';
import 'package:fvapp/features/studio/screens/multi_step_form/multi_step_form.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:get/get.dart';

class RentFormScreen extends StatelessWidget {
  final VoidCallback onNext;
  final Function(Map<String, dynamic>) onFormSubmit;
  final Package package;
  final DateTime selectedDay;
  final int currentStep;

  RentFormScreen({
    Key? key,
    required this.onNext,
    required this.onFormSubmit,
    required this.package,
    required this.selectedDay,
    this.currentStep = 1,
  }) : super(key: key) {
    print('RentFormScreen initialized with packageId: ${package.id}, packageName: ${package.name}');
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Map<String, dynamic> formData = {
      'package': package,
      'packageId': package.id,
      'selectedDay': selectedDay,
      'selectedPackageImageUrl': package.imageUrls.isNotEmpty ? package.imageUrls[0] : '',
      'selectedPackageName': package.name,
      'selectedPackageCategory': package.categoryId, // Assuming categoryId is the category
      'price': package.price,
    };

    return Scaffold(
      appBar: AppBar(title: Text('Form Sewa')),
      body: Column(
        children: [
          MultiStepFormIndicator(
            currentStep: currentStep,
            totalSteps: 3,
          ),
          Expanded(
            child: RentForm(
              formKey: formKey,
              onNext: onNext,
              onFormSubmit: onFormSubmit,
              formData: formData,
              onDescriptionChanged: (value) {
                formData['additionalDescription'] = value;
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (formKey.currentState != null && formKey.currentState!.validate()) {
              if (formData['selectedTema'] == null ||
                  formData['selectedPembayaran'] == null ||
                  formData['additionalDescription'] == null) {
                FVLoaders.errorSnackBar(title: 'Error', message: 'Silakan isi semua form');
              } else {
                // Calculate down payment and remaining payment
                double totalPrice = formData['price'];
                double downPayment = formData['selectedPembayaran'] == 'DP (Down Payment)' ? totalPrice * 0.3 : 0.0;
                double remainingPayment = totalPrice - downPayment;

                formData['downPayment'] = downPayment;
                formData['remainingPayment'] = remainingPayment;

                print('FormData: $formData');

                Get.to(() => CheckoutScreen(
                  formData: formData,
                  onPrevious: () {
                    Navigator.of(context).pop();
                  },
                  currentStep: 3,
                ));
              }
            }
          },
          child: Text('Selanjutnya'),
        ),
      ),
    );
  }
}

class RentForm extends StatefulWidget {
  final VoidCallback onNext;
  final Function(Map<String, dynamic>) onFormSubmit;
  final Function(String?) onDescriptionChanged;
  final Map<String, dynamic> formData;
  final GlobalKey<FormState> formKey;

  const RentForm({
    Key? key,
    required this.onNext,
    required this.onFormSubmit,
    required this.onDescriptionChanged,
    required this.formData,
    required this.formKey,
  }) : super(key: key);

  @override
  _RentFormState createState() => _RentFormState();
}

class _RentFormState extends State<RentForm> {
  String? selectedTema;
  String? selectedPembayaran;
  String? additionalDescription;

  @override
  void initState() {
    super.initState();
    selectedTema = widget.formData['selectedTema'];
    selectedPembayaran = widget.formData['selectedPembayaran'];
    additionalDescription = widget.formData['additionalDescription'];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.event),
                  labelText: 'Tema Acara',
                ),
                value: selectedTema,
                onChanged: (newValue) {
                  setState(() {
                    selectedTema = newValue;
                    widget.formData['selectedTema'] = newValue;
                  });
                },
                items: ['Indoor', 'Outdoor'].map((String tema) {
                  return DropdownMenuItem<String>(
                    value: tema,
                    child: Text(tema),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.payment),
                  labelText: 'Pembayaran',
                ),
                value: selectedPembayaran,
                onChanged: (newValue) {
                  setState(() {
                    selectedPembayaran = newValue;
                    widget.formData['selectedPembayaran'] = newValue;
                  });
                },
                items: ['DP (Down Payment)', 'Lunas'].map((String pembayaran) {
                  return DropdownMenuItem<String>(
                    value: pembayaran,
                    child: Text(pembayaran),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description),
                  labelText: 'Deskripsi Tambahan',
                ),
                onChanged: (value) {
                  setState(() {
                    additionalDescription = value;
                    widget.formData['additionalDescription'] = value;
                  });
                  widget.onDescriptionChanged(value);
                },
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
