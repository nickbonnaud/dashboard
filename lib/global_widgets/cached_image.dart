import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String _url;
  final Size _size;

  const CachedImage({required String url, required Size size, Key? key})
    : _url = url,
      _size = size,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _url,
      imageBuilder: (_, imageProvider) => Material(
        child: Container(
          width: _size.width,
          height: _size.height,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(_url)
            )
          ),
        ),
        elevation: 10,
      ),
      progressIndicatorBuilder: (_, __, ___) => const CircularProgressIndicator()
    );
  }
}