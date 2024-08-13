import 'package:flutter/foundation.dart' show immutable;

@immutable
class Profiles {
  final String classification_name;
  final String classification_number;
  const Profiles({required this.classification_name, required this.classification_number});
}
