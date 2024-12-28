import 'package:flutter/material.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';

class ImageNetworkAppWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  const ImageNetworkAppWidget(
      {super.key,
      required this.imageUrl,
      this.height,
      this.width,
      this.boxFit});

  @override
  Widget build(BuildContext context) {
    return Image.network(imageUrl,
        height: height, width: width, fit: boxFit ?? BoxFit.fitWidth,
        loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Container(
        color: GlobalHelper.getColorSchema(context).surfaceContainer,
        height: height,
        width: width,
        child: Center(
          child: CircularProgressIndicator(
            value: (loadingProgress.expectedTotalBytes != null)
                ? (loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!)
                : null,
          ),
        ),
      );
    }, errorBuilder: (context, error, stackTrace) {
      return Container(
        height: height,
        width: width,
        color: GlobalHelper.getColorSchema(context).surfaceContainer,
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            color: Colors.white,
            size: 75,
          ),
        ),
      );
    });
  }
}
