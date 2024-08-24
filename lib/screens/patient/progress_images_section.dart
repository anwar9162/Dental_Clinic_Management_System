import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import '../../widgets/hover_image.dart'; // Import the HoverImage widget

class ProgressImagesSection extends StatelessWidget {
  final List<PatientImage> progressImages;
  final VoidCallback onAddImage;

  ProgressImagesSection({
    required this.progressImages,
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
                  'Progress Images',
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
            if (progressImages.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0, // Reduced spacing
                  mainAxisSpacing: 8.0, // Reduced spacing
                  childAspectRatio: 1.0, // Maintain aspect ratio
                ),
                itemCount: progressImages.length,
                itemBuilder: (context, index) {
                  final image = progressImages[index];
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
                  'No progress images available',
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
