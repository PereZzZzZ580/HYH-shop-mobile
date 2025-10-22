import '../services/environment.dart';

class ProductImage {
  final String id;
  final String url;
  final String? alt;

  ProductImage({
    required this.id,
    required this.url,
    this.alt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    final rawUrl = (json['url'] ?? '') as String;
    final normalizedUrl = _resolveUrl(rawUrl);
    return ProductImage(
      id: json['id']?.toString() ?? rawUrl,
      url: normalizedUrl,
      alt: json['alt'] as String?,
    );
  }

  static String _resolveUrl(String rawUrl) {
    if (rawUrl.isEmpty) return rawUrl;
    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return rawUrl;
    }
    final base = Environment.assetBaseUrl.replaceAll(RegExp(r'/+$'), '');
    final path = rawUrl.startsWith('/') ? rawUrl : '/$rawUrl';
    return '$base$path';
  }
}

class ProductVariant {
  final String id;
  final double price;
  final double? compareAtPrice;
  final int stock;
  final Map<String, dynamic> attributes;

  const ProductVariant({
    required this.id,
    required this.price,
    required this.stock,
    required this.attributes,
    this.compareAtPrice,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final priceValue = json['price'];
    final compareAtValue = json['compareAtPrice'];
    return ProductVariant(
      id: json['id']?.toString() ?? '',
      price: priceValue is num ? priceValue.toDouble() : 0,
      compareAtPrice: compareAtValue is num ? compareAtValue.toDouble() : null,
      stock: json['stock'] is num ? (json['stock'] as num).toInt() : 0,
      attributes: Map<String, dynamic>.from(json['attributes'] ?? const {}),
    );
  }
}

class ProductCategory {
  final String id;
  final String name;
  final String slug;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
    );
  }
}

class Product {
  final String id;
  final String name;
  final String slug;
  final String description;
  final double price;
  final String imageUrl;
  final String? brand;
  final String? sku;
  final ProductCategory? category;
  final List<ProductImage> images;
  final List<ProductVariant> variants;

  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.brand,
    this.sku,
    this.category,
    this.images = const [],
    this.variants = const [],
  });

  ProductVariant? get primaryVariant => variants.isNotEmpty ? variants.first : null;
  double? get compareAtPrice => primaryVariant?.compareAtPrice;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      if (brand != null) 'brand': brand,
      if (sku != null) 'sku': sku,
      if (category != null)
        'category': {
          'id': category!.id,
          'name': category!.name,
          'slug': category!.slug,
        },
      'images': images
          .map(
            (image) => {
              'id': image.id,
              'url': image.url,
              if (image.alt != null) 'alt': image.alt,
            },
          )
          .toList(),
      'variants': variants
          .map(
            (variant) => {
              'id': variant.id,
              'price': variant.price,
              'stock': variant.stock,
              'attributes': variant.attributes,
              if (variant.compareAtPrice != null) 'compareAtPrice': variant.compareAtPrice,
            },
          )
          .toList(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final variantsData = (json['variants'] as List<dynamic>? ?? [])
        .map((variantJson) => ProductVariant.fromJson(Map<String, dynamic>.from(variantJson as Map)))
        .toList();
    final imagesData = (json['images'] as List<dynamic>? ?? [])
        .map((imageJson) => ProductImage.fromJson(Map<String, dynamic>.from(imageJson as Map)))
        .toList();

    final primaryVariant = variantsData.isNotEmpty ? variantsData.first : null;
    final price = primaryVariant?.price ??
        (json['price'] is num ? (json['price'] as num).toDouble() : 0);

    final rawImageUrl = json['imageUrl']?.toString() ?? '';
    final resolvedImageUrl = rawImageUrl.isNotEmpty
        ? ProductImage._resolveUrl(rawImageUrl)
        : (imagesData.isNotEmpty ? imagesData.first.url : '');

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: price,
      imageUrl: resolvedImageUrl,
      brand: json['brand']?.toString(),
      sku: json['sku']?.toString(),
      category: json['category'] is Map
          ? ProductCategory.fromJson(Map<String, dynamic>.from(json['category'] as Map))
          : null,
      images: imagesData,
      variants: variantsData,
    );
  }
}
