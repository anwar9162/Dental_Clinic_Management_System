import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import '../../widgets/hover_image.dart'; // Import the HoverImage widget

class XrayImagesSection extends StatelessWidget {
  final List<PatientImage> xrayImages;
  final VoidCallback onAddImage;

  XrayImagesSection({
    required this.xrayImages,
    required this.onAddImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Reduced elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Reduced border radius
      ),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'X-Ray Images',
                  style: TextStyle(
                    fontSize: 18, // Reduced font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: onAddImage,
                  child: Text(
                    'Add Image',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14), // Reduced font size
                  ),
                ),
              ],
            ),
            SizedBox(height: 12), // Reduced spacing
            if (xrayImages.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0, // Reduced spacing
                  mainAxisSpacing: 8.0, // Reduced spacing
                  childAspectRatio: 1.0, // Maintain aspect ratio
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
                child: Text(
                  'No X-ray images available',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14), // Reduced font size
                ),
              ),
          ],
        ),
      ),
    );
  }
}
