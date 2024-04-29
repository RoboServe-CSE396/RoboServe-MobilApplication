// Product.dart

class Product {
  late final int _tableNumber;
  late final String _name;
  late final double _price;
  late final String _imagePath = "assets/images/" + _name + ".jpg";



  Product.name(this._name, this._price); // burdaki name simplify edilcek.

  Product(
      this._tableNumber, this._name, this._price);

  String get imagePath => _imagePath;

  double get price => _price;

  set price(final double value) {
    this._price = value;
  }

  String get name => _name;

  set name(final String value) {
    this._name = value;
  }

  int get tableNumber => _tableNumber;

  set tableNumber(final int value) {
    _tableNumber = value;
  }
}
