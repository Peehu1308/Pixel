// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class Upload extends StatefulWidget {
//   const Upload({super.key});

//   @override
//   State<Upload> createState() => _UploadState();
// }

// class _UploadState extends State<Upload> {
//   File? _image;
//   Future pickImage() async {
//     // picker
//     final ImagePicker picker = ImagePicker();
//     // pick from gallery
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     // update image preview
//     if (image != null) {
//       setState(() {
//         _image = File(image.path);
//       });
//     }
//   }

//   Future uploadImage() async {
//     if (_image == null) return;

//     final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     final path = 'upload/$fileName';

//     // upload image to supabase
//     await Supabase.instance.client.storage
//     // to this bucket
//     .from('images')
//     .upload(path, _image!).then((value)=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Image uploaded successfully"))));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           title: const Text('Upload Image'),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               _image != null
//                   ? Image.file(_image!)
//                   : const Text('No image selected'),
//               ElevatedButton(
//                 onPressed: () {
//                   pickImage();
//                 },
//                 child: const Text('Select Image'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   uploadImage();
//                 },
//                 child: const Text('Upload Image'),
//               ),
//             ],
//           ),
//         ));
//   }
// }
