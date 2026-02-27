class CartItem {
  final Map<String, dynamic> product;
  final List<Map<String, dynamic>> selectAddon;
  int quaintity;

  CartItem({
    required this.product,
    required this.selectAddon,
    this.quaintity = 1,
  });

  double get totalprice {
    final double addonprice = selectAddon.fold<double>(
      0,
      (sum, addon) => sum + addon['price'],
    );
    return (product['price'] + addonprice) * quaintity;
  }
}
