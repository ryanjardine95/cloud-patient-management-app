import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerClass extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;

  ImagePickerClass(
    this.imagePickFn,
  );

  @override
  _ImagePickerClassState createState() => _ImagePickerClassState();
}

class _ImagePickerClassState extends State<ImagePickerClass> {
  File _image = new File('');
  bool choice = false;
  bool _imagePicked = false;

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
                imageQuality: 80,
              );
              setState(() {
                _image = File(pickedImage == null ? 'null' : pickedImage.path);
                _imagePicked = true;
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
                _imagePicked = true;
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
        SizedBox(height: 1),
        !_imagePicked
            ? Container(
                width: 200,
                height: 200,
                child: Image.asset(
                    'assets/images/360_F_248426448_NVKLywWqArG2ADUxDq6QprtIzsF82dMF.jpg'),
              )
            : Container(
                height: 200,
                width: 200,
                child: Image.file(_image),
              ),
        SizedBox(
          height: 1,
        ),
        TextButton.icon(
          onPressed: () => _imageSource(context),
          icon: Icon(Icons.image),
          label: Text(_imagePicked ? 'Choose another Image' : 'Choose Image'),
        ),
      ],
    );
  }
}
