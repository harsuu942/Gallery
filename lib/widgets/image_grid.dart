

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart'; // Import for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_app/base/utils/color_utils.dart';
import '../base/utils/font_style.dart';

import '../apis/image_repository.dart';
import '../base/utils/size_constants.dart';
import '../base/utils/utils.dart';
import '../models/image_data.dart';
import '../ui/full_screen_image.dart';


final hoverProvider = StateProvider.family<bool, int>((ref, id) => false);

class ImageGrid extends ConsumerWidget {

  final List<ImageData> images;


  final ScrollController _scrollController = ScrollController();

  ImageGrid({super.key, required this.images});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    _scrollController.addListener(() => _onScroll(ref));

    final crossAxisCount = (MediaQuery.of(context).size.width / 200)
        .floor();

    return MasonryGridView.count(
      crossAxisCount:
          (MediaQuery.of(context).size.width < 600) ? 2 : crossAxisCount,
      // Show 2 columns for mobile devices
      itemCount: images.length,
      controller: _scrollController,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemBuilder: (context, index) {
        final image = images[index];
        return HoverImageItem(image: image);
      },
    );
  }


  void _onScroll(WidgetRef ref) {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(imageProvider.notifier).fetchNextPage();
    }
  }
}

class HoverImageItem extends ConsumerWidget {
  final ImageData image;


  const HoverImageItem({super.key, required this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isHovered = kIsWeb
        ? ref.watch(hoverProvider(image.id)) // Hover on web
        : true;

    return GestureDetector(
      onTap: () => showFullScreenImage(context, image),
      child: kIsWeb
          ? MouseRegion(
              onEnter: (_) =>
                  ref.read(hoverProvider(image.id).notifier).state = true,
              onExit: (_) =>
                  ref.read(hoverProvider(image.id).notifier).state = false,
              child: _buildStack(context, isHovered, image),
            )
          : _buildStack(context, isHovered, image), // No hover on mobile
    );
  }


  Widget _buildStack(BuildContext context, bool isHovered, ImageData image) {
    return Stack(
      children: [
        Hero(
          tag: image.id,
          child: CachedNetworkImage(imageUrl: image.url),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: isHovered ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConstants.size8,
                  horizontal: SizeConstants.size16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black54],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: SizeConstants.size16,
                          ),
                          SizedBox(width: SizeConstants.size4),
                          Text(
                            formatNumber(image.likes.toDouble()), // Like count dynamically
                            style: FontStyle.openSansSemiBoldTextColor_14
                                .copyWith(color: ColorUtils.white),
                          ),
                        ],
                      ),
                      SizedBox(width: SizeConstants.size16),
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                            size: SizeConstants.size16,
                          ),
                          SizedBox(width: SizeConstants.size4),
                          Text(
                            formatNumber(image.views.toDouble()), // View count dynamically
                            style: FontStyle.openSansSemiBoldTextColor_14
                                .copyWith(color: ColorUtils.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }

  void showFullScreenImage(BuildContext context, ImageData image) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),

        reverseTransitionDuration: const Duration(milliseconds: 300),

        pageBuilder: (_, __, ___) => FullScreenImage(image: image),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
