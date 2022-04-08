import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarFade extends StatefulWidget {
  final PickedFile _file;
  final double _size;

  const AvatarFade({required PickedFile file, required double size, Key? key})
    : _file = file,
      _size = size,
      super(key: key);

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
        shape: const CircleBorder(),
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}