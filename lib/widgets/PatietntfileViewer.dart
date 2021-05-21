import 'package:flutter/material.dart';

class PatientFileViewer extends StatelessWidget {
  final url;
  PatientFileViewer({this.url});
  @override
  Widget build(BuildContext context) {
    var deviceConfig = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: deviceConfig.width/1.5,
          decoration: BoxDecoration(
              border: Border.all(
            width: 3,
            color: Theme.of(context).accentColor,
          )),
          height: deviceConfig.height / 2,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Image.network(url, fit: BoxFit.scaleDown, 
              loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
                child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ));
          }),
        ),
        Divider(
          thickness: 3,
        )
      ],
    );
  }
}
