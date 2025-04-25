class NotesScentsFields {
  static const String table = 'notes_scents';
  static const String id = 'id';
  static const String name = 'name';
  static const String noteType = 'note_type';
  static const String isActive = 'is_active';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class NotesScentsModel {
  final String? id;
  final String name;
  final String noteType; // Assuming note_type is a string
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const NotesScentsModel({
    this.id,
    required this.name,
    required this.noteType,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory NotesScentsModel.fromMap(Map<String, dynamic> map) => NotesScentsModel(
    id: map[NotesScentsFields.id],
    name: map[NotesScentsFields.name] ?? '',
    noteType: map[NotesScentsFields.noteType] ?? '',
    isActive: map[NotesScentsFields.isActive] ?? false,
    createdAt: DateTime.tryParse(map[NotesScentsFields.createdAt] ?? '') ?? DateTime.now(),
    updatedAt: map[NotesScentsFields.updatedAt] != null
        ? DateTime.tryParse(map[NotesScentsFields.updatedAt])
        : null,
  );

  Map<String, dynamic> toMap() => {
    NotesScentsFields.id: id,
    NotesScentsFields.name: name,
    NotesScentsFields.noteType: noteType,
    NotesScentsFields.isActive: isActive,
    NotesScentsFields.createdAt: createdAt.toIso8601String(),
    NotesScentsFields.updatedAt: updatedAt?.toIso8601String(),
  };

  NotesScentsModel copyWith({
    String? id,
    String? name,
    String? noteType,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotesScentsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      noteType: noteType ?? this.noteType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'NotesScentsModel(id: $id, name: $name, noteType: $noteType, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}