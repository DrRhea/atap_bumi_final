class EquipmentCategory {
  final int id;
  final String categoryName;
  final String categorySlug;
  final String? categoryDescription;
  final String? categoryIcon;
  final bool isActive;
  final List<EquipmentSubCategory>? subCategories;

  EquipmentCategory({
    required this.id,
    required this.categoryName,
    required this.categorySlug,
    this.categoryDescription,
    this.categoryIcon,
    required this.isActive,
    this.subCategories,
  });

  factory EquipmentCategory.fromJson(Map<String, dynamic> json) =>
      EquipmentCategory(
        id: json['id'],
        categoryName: json['category_name'],
        categorySlug: json['category_slug'],
        categoryDescription: json['category_description'],
        categoryIcon: json['category_icon'],
        isActive: json['is_active'] ?? true,
        subCategories:
            json['sub_categories'] != null
                ? (json['sub_categories'] as List)
                    .map((e) => EquipmentSubCategory.fromJson(e))
                    .toList()
                : null,
      );
}

class EquipmentSubCategory {
  final int id;
  final String subCategoryName;
  final String subCategorySlug;
  final String? subCategoryDescription;
  final int categoryId;
  final bool isActive;

  EquipmentSubCategory({
    required this.id,
    required this.subCategoryName,
    required this.subCategorySlug,
    this.subCategoryDescription,
    required this.categoryId,
    required this.isActive,
  });

  factory EquipmentSubCategory.fromJson(Map<String, dynamic> json) =>
      EquipmentSubCategory(
        id: json['id'],
        subCategoryName: json['sub_category_name'],
        subCategorySlug: json['sub_category_slug'],
        subCategoryDescription: json['sub_category_description'],
        categoryId: json['category_id'],
        isActive: json['is_active'] ?? true,
      );
}
