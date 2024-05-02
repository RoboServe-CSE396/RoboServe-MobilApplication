// Product.dart

class Product {
  late final String _name;
  late final double _price;
  int quantity = 1;
  late final String _imagePath = "assets/images/" + _name + ".png";



  Product.name(this._name, this._price); // burdaki name simplify edilcek.

  Product(
      this._name, this._price);

  String get imagePath => _imagePath;

  double get price => _price;

  set price(final double value) {
    this._price = value;
  }

  String get name => _name;

  set name(final String value) {
    this._name = value;
  }

}
