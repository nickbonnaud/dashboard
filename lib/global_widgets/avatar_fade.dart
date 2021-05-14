import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarFade extends StatefulWidget {
  final PickedFile _file;
  final double _size;

  AvatarFade({required PickedFile file, required double size})
    : _file = file,
      _size = size;

  @override
  State<AvatarFade> createState() => _AvatarFade();
}

class _AvatarFade extends State<AvatarFade> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800)
    )..forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _controller.value,
      duration: Duration(milliseconds: 800),
      child: Material(
        child: Container(
          width: widget._size * 2,
          height: widget._size * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(widget._file.path)
            )
          ),
        ),
        elevation: 10,
        shape: CircleBorder(),
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}