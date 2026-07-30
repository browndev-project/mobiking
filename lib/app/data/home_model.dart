import 'package:flutter/material.dart';

import 'group_model.dart';

class HomeLayoutModel {
  final String id;
  final bool active;
  final List<String> banners;
  final List<GroupModel> groups;
  final List<CategoryModel> categories; // NEW: Add categories list

  HomeLayoutModel({
    required this.id,
    required this.active,
    required this.banners,
    required this.groups,
    required this.categories, // NEW: Add categories to constructor
  });

  factory HomeLayoutModel.fromJson(Map<String, dynamic> json) {
    final groupsJson = json['groups'];
    List<GroupModel> groupsList = [];

    if (groupsJson != null && groupsJson is List) {
      groupsList = groupsJson
          .whereType<Map<String, dynamic>>()
          .map((e) => GroupModel.fromJson(e))
          .toList();
    } else {
      debugPrint("Warning: groups is null or not a List: $groupsJson");
    }

    final bannersJson = json['banners'];
    List<String> bannersList = [];
    if (bannersJson != null && bannersJson is List) {
      bannersList = List<String>.from(bannersJson);
    } else {
      debugPrint("Warning: banners is null or not a List: $bannersJson");
    }

    // NEW: Parse categories from JSON
    final categoriesJson = json['categories'];
    List<CategoryModel> categoriesList = [];
    if (categoriesJson != null && categoriesJson is List) {
      categoriesList = categoriesJson
          .whereType<Map<String, dynamic>>()
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } else {
      debugPrint("Warning: categories is null or not a List: $categoriesJson");
    }
    // END NEW PARSING

    return HomeLayoutModel(
      id: json['_id'] ?? '',
      active: json['active'] ?? false,
      banners: bannersList,
      groups: groupsList,
      categories: categoriesList, // NEW: Pass parsed categories
    );
  }
}

// Updated CategoryModel with the 'icon' and 'theme' field
class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final int sequenceNo;
  final String? upperBanner;
  final String? lowerBanner;
  final bool active;
  final bool featured;
  final List<String> photos;
  final String? parentCategory;
  final List<String> products;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? deliveryCharge; // ✅ changed from int? to double?
  final double? minFreeDeliveryOrderAmount; // ✅ changed
  final double? minOrderAmount; // ✅ changed
  final String? icon;
  final String? theme;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.sequenceNo,
    this.upperBanner,
    this.lowerBanner,
    required this.active,
    required this.featured,
    required this.photos,
    this.parentCategory,
    required this.products,
    required this.createdAt,
    required this.updatedAt,
    this.deliveryCharge,
    this.minFreeDeliveryOrderAmount,
    this.minOrderAmount,
    this.icon,
    this.theme,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(dynamic listData) {
      if (listData is List) {
        return listData
            .map((e) => e is String ? e : (e is Map ? (e['_id']?.toString() ?? e.toString()) : e.toString()))
            .where((s) => s.isNotEmpty)
            .toList();
      }
      return [];
    }

    String? parseParentCategory(dynamic parent) {
      if (parent is String) return parent;
      if (parent is Map) return parent['_id']?.toString() ?? parent['name']?.toString();
      return null;
    }

    int parseInt(dynamic val) {
      if (val is int) return val;
      if (val is double) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    double? parseDouble(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val);
      return null;
    }

    return CategoryModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      sequenceNo: parseInt(json['sequenceNo']),
      upperBanner: json['upperBanner']?.toString(),
      lowerBanner: json['lowerBanner']?.toString(),
      active: json['active'] is bool ? json['active'] as bool : (json['active'] == 1 || json['active'] == 'true'),
      featured: json['featured'] is bool ? json['featured'] as bool : (json['featured'] == 1 || json['featured'] == 'true'),
      photos: parseStringList(json['photos']),
      parentCategory: parseParentCategory(json['parentCategory']),
      products: parseStringList(json['products']),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      deliveryCharge: parseDouble(json['deliveryCharge']),
      minFreeDeliveryOrderAmount: parseDouble(json['minFreeDeliveryOrderAmount']),
      minOrderAmount: parseDouble(json['minOrderAmount']),
      icon: json['icon']?.toString(),
      theme: json['theme']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'sequenceNo': sequenceNo,
      'upperBanner': upperBanner,
      'lowerBanner': lowerBanner,
      'active': active,
      'featured': featured,
      'photos': photos,
      'parentCategory': parentCategory,
      'products': products,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deliveryCharge': deliveryCharge,
      'minFreeDeliveryOrderAmount': minFreeDeliveryOrderAmount,
      'minOrderAmount': minOrderAmount,
      'icon': icon,
      'theme': theme,
    };
  }
}
