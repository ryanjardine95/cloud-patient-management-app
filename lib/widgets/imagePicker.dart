import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerClass extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;
  ImagePickerClass(this.imagePickFn);

  @override
  _ImagePickerClassState createState() => _ImagePickerClassState();
}

class _ImagePickerClassState extends State<ImagePickerClass> {
  File _image = new File('');
  bool choice = false;

  void _imageSource(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text('Camera or Gallery'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final pickedImage = await ImagePicker().getImage(
                source: ImageSource.camera,
                imageQuality: 60,
              );
              setState(() {
                _image = File(pickedImage == null ? 'null' : pickedImage.path);
              });
              widget.imagePickFn(
                  File(pickedImage == null ? 'null' : pickedImage.path));
              setState(() {
                choice = false;
              });
            },
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final pickedImage = await ImagePicker().getImage(
                source: ImageSource.gallery,
                imageQuality: 60,
              );
              setState(() {
                _image = File(pickedImage == null ? 'null' : pickedImage.path);
              });
              widget.imagePickFn(
                  File(pickedImage == null ? 'null' : pickedImage.path));
              setState(() {
                choice = false;
              });
            },
            child: Text('Gallery'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Image.file(_image),
        SizedBox(
          height: 10,
        ),
        TextButton.icon(
          onPressed: () => _imageSource(context),
          icon: Icon(Icons.image),
          label: Text('Choose Image'),
        ),
      ],
    );
  }
}
