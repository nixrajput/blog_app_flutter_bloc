import 'package:blog_api_app/widgets/loaders/shimmer_loading_effect.dart';
import 'package:flutter/material.dart';

class PostLoadingShimmer extends StatelessWidget {
  final double width;
  final double height;

  PostLoadingShimmer({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerLoadingWidget(
                  width: screenSize.width,
                  height: 50.0,
                ),
                SizedBox(height: 4.0),
                ShimmerLoadingWidget(
                  width: screenSize.width,
                  height: screenSize.height * 0.4,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerLoadingWidget(
                  width: screenSize.width,
                  height: 50.0,
                ),
                SizedBox(height: 4.0),
                ShimmerLoadingWidget(
                  width: screenSize.width,
                  height: screenSize.height * 0.4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
