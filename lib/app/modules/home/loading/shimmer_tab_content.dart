import 'package:flutter/material.dart';
import 'package:mobiking/app/modules/home/loading/shimmer_banner.dart';
import 'package:mobiking/app/modules/home/loading/shimmer_group_section.dart';
import 'package:mobiking/app/modules/home/loading/shimmer_product_grid.dart';

class ShimmerTabContent extends StatelessWidget {
  const ShimmerTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          ShimmerBanner(width: double.infinity, height: 160, borderRadius: 12),
          SizedBox(height: 8),
          ShimmerGroupSection(),
          ShimmerProductGrid(),
        ],
      ),
    );
  }
}
