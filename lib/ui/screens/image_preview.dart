import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String url;
  const ImagePreviewScreen(this.url, {super.key});
  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: FadeInImage(
              image: NetworkImage(widget.url),
              placeholder: NetworkImage(widget.url),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
