// lib/features/products/data/model/product.dart

class Product {
  final String id;
  final String name;
  final double price;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawName = json['productName'] ?? '';
    final parsedName = cleanName(rawName, 'ar'); // اختاري 'en' لو عايزة إنجليزي
    return Product(
      id: json['productID']?.toString() ?? '',
      name: parsedName,
      price: (json['standardUnitPrice'] ?? 0).toDouble(),
    );
  }
}

/// تنظف الاسم وتعرضه حسب اللغة المطلوبة
String cleanName(String text, String lang) {
  if (!isI18nText(text)) return text;

  final parsedTags = _parseTags(text);
  if (parsedTags.isEmpty) return text;

  if (parsedTags.containsKey(lang.toLowerCase())) {
    return parsedTags[lang.toLowerCase()]!;
  }

  // رجع أي لغة تانية موجودة لو اللغة المطلوبة مش موجودة
  return parsedTags.values.first;
}

/// تتحقق إذا كان النص يحتوي على علامات i18n مثل [ar=سفن أب]
bool isI18nText(String text) {
  return text.contains(RegExp(r'\[[a-zA-Z]+=[^\]]+\]'));
}

/// تستخرج القيم من النص بصيغة [ar=سفن أب][EN=7UP]
Map<String, String> _parseTags(String text) {
  final regExp = RegExp(r'\[([a-zA-Z]+)=([^\]]+)\]');
  final matches = regExp.allMatches(text);

  final Map<String, String> parsed = {};
  for (var match in matches) {
    final key = match.group(1)?.toLowerCase();
    final value = match.group(2);
    if (key != null && value != null) {
      parsed[key] = value;
    }
  }

  return parsed;
}


class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    final raw = json['category'] ?? '';
    final name = cleanName(raw, 'ar'); // ← غير هنا إلى "en" لو عايز إنجليزي
    return Category(
      id: json['categoryID'] ?? '',
      name: name,
    );
  }
}
