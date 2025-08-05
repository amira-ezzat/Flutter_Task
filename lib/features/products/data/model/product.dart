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
    final parsedName = cleanName(rawName, 'ar');
    return Product(
      id: json['productID'] ?? '',
      name: parsedName,
      price: (json['standardUnitPrice'] ?? 0).toDouble(),
    );
  }
}

// ===============
// Helper Functions
// ===============

/// تنظف الاسم وتعرضه حسب اللغة المطلوبة
String cleanName(String text, String lang) {
  if (!isI18nText(text)) return text;

  final parsedTags = _parseTags(text);

  if (parsedTags.isEmpty) return text;

  // لو فيه عربي وإنجليزي
  if (parsedTags.containsKey('ar') && parsedTags.containsKey('en')) {
    return parsedTags[lang.toLowerCase()] ?? text;
  }

  // لو مفيش غير لغة واحدة فقط
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
