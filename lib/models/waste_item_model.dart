class WasteItemModel {
  String id;
  String sellerId;
  String title;
  String description;
  String type;
  num price;

  WasteItemModel(
      {required this.id,
      required this.sellerId,
      required this.title,
      required this.description,
      required this.type,
      required this.price});

  Map<String, dynamic> toMap() {
    return {'id': id, 'sellerId': sellerId, 'title': title, 'description': description, 'type': type, 'price': price};
  }

  static WasteItemModel fromJSON(Map<String, dynamic> data) => WasteItemModel(
      id: data['id'],
      sellerId: data['sellerId'],
      title: data['title'],
      description: data['description'],
      type: data['type'],
      price: data['price']);
}
