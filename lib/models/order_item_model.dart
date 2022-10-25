class OrderItemModel {
  String id;
  String title;
  String description;
  String type;
  int qty;
  String seller;

  OrderItemModel(
      {required this.id,
      required this.seller,
      required this.qty,
      required this.title,
      required this.description,
      required this.type});

  static OrderItemModel fromJSON(Map<String, dynamic> data) => OrderItemModel(
      id: data['id'],
      seller: data['seller'],
      qty: data['qty'],
      title: data['title'],
      description: data['description'],
      type: data['type']);
}
