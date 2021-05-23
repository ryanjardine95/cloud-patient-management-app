import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenFileViewer extends StatefulWidget {
  static const routeName = '/FullScreenFileViewer';

  final url;
  final tag;
  FullScreenFileViewer({this.tag, this.url});
  @override
  _FullScreenFileViewerState createState() => _FullScreenFileViewerState();
}

class _FullScreenFileViewerState extends State<FullScreenFileViewer> {

   @override
  initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    //SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onDoubleTap: () => Navigator.of(context).pop(),
                child: Hero(
                  
            tag: widget.tag,
            child: CachedNetworkImage(
              imageUrl: widget.url,
            ),
          ),
        ),
      ),
    );
  }
}
