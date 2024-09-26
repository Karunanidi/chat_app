import 'package:flutter/material.dart';
import 'package:flutter_chat/features/homepage_screen/controller/image_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePickerController _imagePickerController =
      Get.put(ImagePickerController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Display the selected image
        Obx(() {
          if (_imagePickerController.selectedImage.value != null) {
            return CircleAvatar(
              radius: 40,
              backgroundImage:
                  FileImage(_imagePickerController.selectedImage.value!),
            );
          } else {
            return const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
            );
          }
        }),
        const SizedBox(height: 10),
        // Button to pick an image from the gallery
        TextButton.icon(
          onPressed: () {
            _imagePickerController.pickImage(ImageSource.camera);
          },
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
        ),
        // Button to upload the selected image (with compression)
        Obx(() {
          if (_imagePickerController.isUploading.value) {
            return const Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Uploading...'),
              ],
            );
          } else {
            return ElevatedButton(
              onPressed: _imagePickerController.uploadImageToFirebaseStorage,
              child: const Text('Upload Image'),
            );
          }
        }),
        const SizedBox(height: 10),
        // Optional: Button to clear the selected image
        TextButton.icon(
          onPressed: _imagePickerController.clearImage,
          icon: const Icon(Icons.clear),
          label: const Text('Clear Image'),
        ),
        const SizedBox(height: 10),
        // Show success or error messages
        Obx(() {
          if (_imagePickerController.uploadSuccessMessage.value.isNotEmpty) {
            return Text(
              _imagePickerController.uploadSuccessMessage.value,
              style: TextStyle(
                color: _imagePickerController.uploadSuccessMessage.value
                        .contains('successful')
                    ? Colors.green
                    : Colors.red,
              ),
            );
          }
          return const SizedBox();
        }),
      ],
    );
  }
}
