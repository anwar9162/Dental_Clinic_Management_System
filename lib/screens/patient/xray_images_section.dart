import 'package:flutter/material.dart';

import '../../models/patient_model.dart';

import '../../widgets/hover_image.dart'; // Import the HoverImage widget

class XrayImagesSection extends StatelessWidget {
  final List<PatientImage> xrayImages;
  final VoidCallback onAddImage;

  XrayImagesSection({required this.xrayImages, required this.onAddImage});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'X-Ray Images',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: onAddImage,
                  child: Text(
                    'Add Image',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (xrayImages.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.00,
                ),
                itemCount: xrayImages.length,
                itemBuilder: (context, index) {
                  final image = xrayImages[index];
                  return HoverImage(
                    imagePath:
                        'http://localhost:5000/images/${image.assetPath}', // Use URL
                    dateCaptured: image.dateCaptured,
                  );
                },
              )
            else
              Center(
                child: Text('No X-ray images available',
                    style: TextStyle(color: Colors.grey[600])),
              ),
          ],
        ),
      ),
    );
  }
}
