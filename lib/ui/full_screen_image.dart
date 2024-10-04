// widgets/full_screen_image.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/base/utils/color_utils.dart';
import '../models/image_data.dart';

class FullScreenImage extends StatelessWidget {

  final ImageData image;

  const FullScreenImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (didPop) {
         Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: ColorUtils.white,
        body: GestureDetector(
          onVerticalDragEnd: (_) => Navigator.pop(context),
          onHorizontalDragEnd: (_) => Navigator.pop(context),
          onTap: () => Navigator.pop(context), // Detect tap
          child: Center(
            child: Hero(
              tag: image.id, // Unique tag for hero animation
              child: CachedNetworkImage(imageUrl: image.url),
            ),
          ),
        ),
      ),
    );
  }
}
