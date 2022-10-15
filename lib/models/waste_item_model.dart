class WasteItemModel {
  String id;
  String title;
  String description;
  String type;
  int stock;
  double price;
  String imgURL;

  WasteItemModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.type,
      required this.stock,
      required this.price,
      required this.imgURL});

  static WasteItemModel fromJSON(Map<String, dynamic> data) => WasteItemModel(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      type: data['type'],
      stock: data['stock'],
      price: data['price'],
      imgURL: data['imgURL']);
}
