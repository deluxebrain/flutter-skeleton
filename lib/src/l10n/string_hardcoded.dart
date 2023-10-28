/// A simple placeholder that can be used to search all the hardcoded strings
/// in the code (useful to identify strings that need to be localized).
extension StringHardcoded on String {
  // e.g. title: Text('An error occurred'.hardcoded),
  String get hardcoded => this;
}
