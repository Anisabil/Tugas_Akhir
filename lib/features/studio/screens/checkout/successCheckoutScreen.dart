import 'package:flutter/material.dart';
import 'package:fvapp/common/styles/spacing_styles.dart';
import 'package:fvapp/features/studio/screens/biodata/biodata_form.dart';
import 'package:fvapp/features/studio/screens/invoice/invoice.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/constants/text_strings.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class SuccessCheckoutScreen extends StatelessWidget {
  const SuccessCheckoutScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.onPressed});

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final InvoicePdf invoicepdf = InvoicePdf();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: FVSpacingStyle.paddingWidthAppBarHeight * 2,
          child: Column(
            children: [
              // Image
              Image(
                image: AssetImage(image),
                width: FVHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FVSizes.spaceBtwItems),

              Text(
                subTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final data = await invoicepdf.generateInvoicePDF();
                        invoicepdf.savePdfFile("KR PDF", data);
                      },
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.document_text), // Ganti dengan ikon yang Anda inginkan
                          SizedBox(height: 5),
                          Text(FVText.fvInvoice),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: FVSizes.spaceBtwInputFields),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPressed,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.messages),
                          SizedBox(height: 5),
                          Text(FVText.fvCall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FVSizes.spaceBtwSection),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Get.to(() => const BiodataScreen()),
                    child: const Text(FVText.fvBiodata)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(FVSizes.defaultSpace),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onPressed,
            child: const Text(FVText.fvContinue),
          ),
        ),
      ),
    );
  }
}
