import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

class LazyLoadingList extends StatefulWidget {
  const LazyLoadingList({super.key});

  @override
  LazyLoadingListState createState() => LazyLoadingListState();
}

class LazyLoadingListState extends State<LazyLoadingList> {
  static const _pageSize = 20;
  final PagingController<int, String> _pagingController = PagingController(firstPageKey: 0);
  final List<String> imageList = [
    "https://d-media.gnammus.com/image/00848bc2-781b-496e-bb90-298acea6fbdd_original.webp",
    "https://d-media.gnammus.com/image/5c73152f-8b84-4535-9565-38e81b40733b_original.webp",
    "https://d-media.gnammus.com/image/f1c50267-3c49-4b7d-9910-240c73e63ecf_original.webp",
    "https://d-media.gnammus.com/image/88a711a2-1050-48fa-9054-4bbffba2b1c2_original.webp",
    "https://d-media.gnammus.com/image/942cab8c-a879-4a9f-8371-451f81a5a7b0_original.webp",
    "https://d-media.gnammus.com/image/8cfefd2d-e55a-41b3-a3ec-c9cfec70207c_original.webp",
    "https://d-media.gnammus.com/image/76447ebc-bdea-42f5-9ea0-6484ae3daaed_original.webp",
    "https://d-media.gnammus.com/image/43d53cbd-8573-4ff8-8529-cdedacb23b2d_original.webp",
    "https://d-media.gnammus.com/image/7f2b6f2c-d49c-4b96-b76a-be3ab9d0bf72_original.webp",
    "https://fakeimg.pl/250x250/ffbb00/000000"
  ];

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = List.generate(_pageSize, (index) => "Item ${(pageKey * _pageSize) + index}");
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  // Test with precacheImage
  // @override
  // Widget build(BuildContext context) {
  //   return PagedListView<int, String>(
  //     pagingController: _pagingController,
  //     builderDelegate: PagedChildBuilderDelegate<String>(
  //       itemBuilder: (context, item, index) {
  //         final imageUrl = getImageUrl();
  //         final imageProvider = CachedNetworkImageProvider(imageUrl);
  //         precacheImage(imageProvider, context);
  //         return CachedNetworkImage(
  //           imageUrl: imageUrl,
  //           useOldImageOnUrlChange: true,
  //           fadeInCurve: Curves.linear,
  //           fadeOutCurve: Curves.linear,
  //           fadeOutDuration: Duration.zero,
  //           fadeInDuration: Duration.zero,
  //           placeholder: (context, url) => Shimmer.fromColors(
  //             baseColor: Colors.grey[300]!,
  //             highlightColor: Colors.grey[100]!,
  //             child: Container(
  //               height: 150.0,
  //               color: Colors.amber,
  //             ),
  //           ),
  //           errorWidget: (context, url, error) => const Icon(Icons.error),
  //         );
  //       },
  //     ),
  //   );
  // }

  // Test without precacheImage
  @override
  Widget build(BuildContext context) {
    return PagedListView<int, String>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<String>(
        itemBuilder: (context, item, index) => CachedNetworkImage(
          imageUrl: getImageUrl(),
          useOldImageOnUrlChange: true,
          fadeInCurve: Curves.linear,
          fadeOutCurve: Curves.linear,
          fadeOutDuration: Duration.zero,
          fadeInDuration: Duration.zero,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 150.0,
              color: Colors.amber,
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  String getImageUrl(){
    final random = Random();
    var i = random.nextInt(imageList.length);
    return imageList[i];
  }
}