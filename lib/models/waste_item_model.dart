class WasteItemModel {
  String id;
  String title;
  String description;
  String type;
  int stock;

  WasteItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.stock,
    // required this.price
  });

  static WasteItemModel fromJSON(Map<String, dynamic> data) => WasteItemModel(
      id: data['id'], title: data['title'], description: data['description'], type: data['type'], stock: data['stock']);
}
