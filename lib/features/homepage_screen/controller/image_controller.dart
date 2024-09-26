// File path: controllers/image_picker_controller.dart
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

class ImagePickerController extends GetxController {
  var selectedImage = Rxn<File>();
  var isUploading = false.obs;
  var uploadedImageUrl = ''.obs;
  var uploadSuccessMessage = ''.obs;
  var currentUser = FirebaseAuth.instance.currentUser.obs;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Pick an image from the gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      log("Error picking image: $e");
    }
  }

  // Compress image using ffmpeg
  Future<File?> compressImage(File imageFile) async {
    final String outputPath = '${imageFile.path}_compressed.jpg';

    log('Original file size: ${imageFile.lengthSync()} bytes',
        name: 'Compression');

    // ffmpeg command to compress the image
    final command = '-i ${imageFile.path} -vf scale=iw*0.5:-1 $outputPath';

    // Run ffmpeg compression
    await FFmpegKit.execute(command);

    final compressedFile = File(outputPath);
    if (await compressedFile.exists()) {
      log('Compressed file size: ${compressedFile.lengthSync()} bytes',
          name: 'Compression');
      return compressedFile;
    } else {
      log("Compression failed");
      return null;
    }
  }

  // Upload image to Firebase Storage (only if user is authenticated)
  Future<void> uploadImageToFirebaseStorage() async {
    if (currentUser.value == null) {
      uploadSuccessMessage.value = 'You must be logged in to upload images.';
      return;
    }

    if (selectedImage.value == null) {
      uploadSuccessMessage.value = 'No image selected';
      return;
    }

    try {
      isUploading.value = true;
      uploadSuccessMessage.value = '';
      var name = currentUser.value!.displayName;
      var email = currentUser.value!.email;
      var user = currentUser.value!.displayName != null ? name : email;

      // Compress the image before uploading
      final compressedImage = await compressImage(selectedImage.value!);

      if (compressedImage == null) {
        uploadSuccessMessage.value = 'Image compression failed';
        return;
      }

      final fileName = basename(compressedImage.path);

      // Create a reference to Firebase Storage using the user's UID as part of the path
      Reference storageRef = _storage.ref().child(
          'user_uploads/images/profile/${currentUser.value!.uid}$user/$fileName');

      log('filepath: $storageRef', name: 'storage');
      log('filename: $fileName', name: 'storage');

      // Start the upload task
      UploadTask uploadTask = storageRef.putFile(compressedImage);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        log('Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      });

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL after the upload
      String downloadUrl = await storageRef.getDownloadURL();
      uploadedImageUrl.value = downloadUrl;
      log('imageUrl: $downloadUrl');
    } catch (e) {
      uploadSuccessMessage.value = 'Error during upload: $e';
    } finally {
      isUploading.value = false;
    }
  }

  // Clear the selected image
  void clearImage() {
    selectedImage.value = null;
  }
}
