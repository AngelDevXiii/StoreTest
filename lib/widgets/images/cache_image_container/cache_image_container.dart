import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheImageContainer extends StatelessWidget {
  const CacheImageContainer({
    super.key,
    required this.imageUrl,
    this.imageBuilder,
  });

  final String imageUrl;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      progressIndicatorBuilder:
          (context, url, progress) => Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(value: progress.progress),
            ),
          ),
      imageUrl: imageUrl,
      imageBuilder: imageBuilder,
      errorWidget:
          (context, url, error) => Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey,
              size: 20.0,
            ),
          ),
    );
  }
}
