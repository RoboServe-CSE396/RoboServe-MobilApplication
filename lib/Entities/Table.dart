
class Table{
  late String _name;
  late String _location;

  Table.name(this._name, this._location);

  String get location => _location;

  set location(final String value) {
    this._location = value;
  }

  String get name => _name;

  set name(final String value) {
    this._name = value;
  }
}