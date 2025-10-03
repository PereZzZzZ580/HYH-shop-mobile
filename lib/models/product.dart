class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String? category;      // Campo adicional que puede estar en tu esquema Prisma
  final String? brand;         // Campo adicional que puede estar en tu esquema Prisma
  final int? stock;            // Campo adicional que puede estar en tu esquema Prisma
  final bool? available;       // Campo adicional que puede estar en tu esquema Prisma
  final String? sku;           // Campo adicional que puede estar en tu esquema Prisma

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.category,
    this.brand,
    this.stock,
    this.available,
    this.sku,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      if (category != null) 'category': category,
      if (brand != null) 'brand': brand,
      if (stock != null) 'stock': stock,
      if (available != null) 'available': available,
      if (sku != null) 'sku': sku,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] is int) ? (json['price'] as int).toDouble() : json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      stock: json['stock'] as int?,
      available: json['available'] as bool?,
      sku: json['sku'] as String?,
    );
  }
}
