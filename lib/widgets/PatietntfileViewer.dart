import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_patient_management/widgets/fullScreenFileViewer.dart';
import 'package:flutter/material.dart';

class PatientFileViewer extends StatelessWidget {
  final url;
  final tag;
  PatientFileViewer({this.url, this.tag});
  @override
  Widget build(BuildContext context) {
    var deviceConfig = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return FullScreenFileViewer(tag: tag, url: url);
                },
              ),
            );
          },
          child: Container(
            width: deviceConfig.width / 1.5,
            decoration: BoxDecoration(
                border: Border.all(
              width: 3,
              color: Theme.of(context).accentColor,
            )),
            height: deviceConfig.height / 2,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Hero(
              tag: tag,
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.scaleDown,
                placeholder: (ctx, url) => Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
          ),
        ),
        Divider(
          thickness: 3,
        ),
      ],
    );
  }
}
