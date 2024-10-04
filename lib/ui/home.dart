import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_app/base/utils/size_constants.dart';
import 'package:gallery_app/base/utils/utils.dart';
import '../apis/image_repository.dart';
import '../base/utils/color_utils.dart';
import '../base/utils/font_style.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/image_grid.dart';


class Home extends StatelessWidget {

  final VoidCallback onFullScreenImage;


  const Home({super.key, required this.onFullScreenImage});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double imageSize = screenWidth > SizeConstants.size600
        ? SizeConstants.size100
        : SizeConstants.size50;

    setStatusBar(); // Set status bar style
    return Scaffold(
        appBar: buildCustomAppBar(imageSize),
        backgroundColor: ColorUtils.white,
        body: Consumer(
          builder: (context, ref, child) {
            final images = ref.watch(imageProvider);
            return ImageGrid(images: images);
          },
        ),
    );
  }

  PreferredSizeWidget buildCustomAppBar(double imageSize) {
    return PreferredSize(
      preferredSize: Size.fromHeight(SizeConstants.size100),
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConstants.size30,
          right: SizeConstants.size30,
          top: SizeConstants.size14,
          bottom: SizeConstants.size2,
        ),
        child: SizedBox(
          height: SizeConstants.size80,
          width: double.infinity,
          child: Row(
            children: [
              // Image.asset(
              //   'assets/images/ic_pixabay_logo.png',
              //   height: imageSize,
              //   width: imageSize,
              // ),
              SizedBox(width: SizeConstants.size10),
              const Expanded(
                child: SearchField(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SearchField extends ConsumerWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Timer? debounceTimer;

    return CustomTextField(
      cursorColor: ColorUtils.black,
      textInputAction: TextInputAction.search,
      controller: TextEditingController(),
      textInputType: TextInputType.text,
      valueHintTextStyle: FontStyle.openSansSemiBoldTextColor_16.copyWith(
        color: ColorUtils.darkGrey,
      ),
      valueTextStyle: FontStyle.openSansSemiBoldTextColor_16,
      hint: 'Search Gallery',
      focusNode: FocusNode(),
      boxColor: ColorUtils.grey,
      prefixIcon: const Icon(Icons.search),
      prefixIconColor: ColorUtils.darkGrey,
      onChanged: (value) {
        if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
        debounceTimer = Timer(
          const Duration(milliseconds: 500),
              () {
            ref.read(searchQueryProvider.notifier).state = value;
            ref.read(imageProvider.notifier).reset();
          },
        );
      },
    );
  }
}
