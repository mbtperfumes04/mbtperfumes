import 'package:mbtperfumes/models/notes_scent_model.dart';
import 'package:uuid/uuid.dart';

class CustomScentItem {
  final String id;
  final NotesScentsModel scent;
  final int value;
  final String noteType;

  const CustomScentItem({
    required this.id,
    required this.scent,
    required this.value,
    required this.noteType
  });
}

class CustomSizeItem {
  final String id;
  final int size;
  final int quantity;

  CustomSizeItem({
    String? id,
    required this.size,
    required this.quantity,
  }) : id = id ?? const Uuid().v4();

  CustomSizeItem copyWith({
    String? id,
    int? size,
    int? quantity,
  }) {
    return CustomSizeItem(
      id: id ?? this.id,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }
}