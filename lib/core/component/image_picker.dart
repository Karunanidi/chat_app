import 'package:flutter/material.dart';
import 'package:flutter_chat/features/profile_screen/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ProfileController _imagePickerController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Show selected images
        Obx(() {
          var imageFile = _imagePickerController.selectedImage.value;
          if (imageFile != null) {
            return CircleAvatar(
              radius: 40,
              backgroundImage: FileImage(imageFile),
            );
          } else {
            return const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            );
          }
        }),
        const SizedBox(height: 10),
        // Button to select images
        TextButton.icon(
          onPressed: () {
            _imagePickerController.pickImage(ImageSource.camera);
          },
          icon: const Icon(Icons.image),
          label: const Text('Add Images'),
        ),
      ],
    );
  }
}
