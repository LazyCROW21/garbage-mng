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
      appBar: AppBar(
        title: const Text('Image Preview'),
      ),
      body: Center(
        child: Hero(
          tag: 'imageHero',
          child: InteractiveViewer(
            clipBehavior: Clip.none,
            child: FadeInImage(
              fit: BoxFit.cover,
              image: NetworkImage(widget.url),
              placeholder: const AssetImage('assets/images/loading.gif'),
            ),
          ),
        ),
      ),
    );
  }
}
