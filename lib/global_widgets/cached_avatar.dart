import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedAvatar extends StatelessWidget {
  final String _url;
  final double _size;

  CachedAvatar({required String url, required double size})
    : _url = url,
      _size = size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _url,
      imageBuilder: (_, imageProvider) => Material(
        child: Container(
          width: _size * 2,
          height: _size * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(_url)
            )
          ),
        ),
        elevation: 10,
        shape: CircleBorder(),
      ),
      progressIndicatorBuilder: (_, __, ___) => CircularProgressIndicator()
    );
  }
}