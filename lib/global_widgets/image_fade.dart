import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFade extends StatefulWidget {
  final PickedFile _file;
  final Size _size;
  
  const ImageFade({required PickedFile file, required Size size, Key? key})
    : _file = file,
      _size = size,
      super(key: key);

  @override
  State<ImageFade> createState() => _ImageFade();
}

class _ImageFade extends State<ImageFade> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800)
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _controller.value,
      duration: const Duration(milliseconds: 800),
      child: Material(
        child: Container(
          width: widget._size.width,
          height: widget._size.height,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(widget._file.path)
            )
          ),
        ),
        elevation: 10,
        shape: const ContinuousRectangleBorder(),
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}