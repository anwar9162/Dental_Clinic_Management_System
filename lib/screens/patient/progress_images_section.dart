import 'package:flutter/material.dart';

import '../../models/patient_model.dart';

import '../../widgets/hover_image.dart'; // Import the HoverImage widget

class ProgressImagesSection extends StatelessWidget {
  final List<PatientImage> progressImages;
  final VoidCallback onAddImage;

  ProgressImagesSection(
      {required this.progressImages, required this.onAddImage});

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
                  'Progress Images',
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
            if (progressImages.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.00,
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
                child: Text('No progress images available',
                    style: TextStyle(color: Colors.grey[600])),
              ),
          ],
        ),
      ),
    );
  }
}
