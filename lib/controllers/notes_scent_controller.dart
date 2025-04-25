import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notes_scent_model.dart';

class NotesScentsController {
  final SupabaseClient _client = Supabase.instance.client;
  final String table = NotesScentsFields.table;

  // CREATE
  Future<void> addNotesScentsItem(NotesScentsModel item) async {
    try {
      await _client.from(table).insert(item.toMap());
    } catch (e) {
      print('Error adding notes scent item: $e');
      rethrow;
    }
  }

  // READ
  Future<List<NotesScentsModel>> fetchNotesScentsItems() async {
    final response = await _client.from(table).select();
    return (response as List)
        .map((item) => NotesScentsModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  // READ
  Future<NotesScentsModel?> getNotesScentsItemById(String id) async {
    final response = await _client
        .from(table)
        .select()
        .eq(NotesScentsFields.id, id)
        .maybeSingle();

    if (response != null) {
      return NotesScentsModel.fromMap(response);
    }
    return null;
  }

  // UPDATE
  Future<void> updateNotesScentsItem(NotesScentsModel item) async {
    try {
      await _client
          .from(table)
          .update(item.toMap())
          .eq(NotesScentsFields.id, item.id ?? '');
    } catch (e) {
      print('Error updating notes scent item: $e');
      rethrow;
    }
  }

  // DELETE
  Future<void> deleteNotesScentsItem(String id) async {
    try {
      await _client.from(table).delete().eq(NotesScentsFields.id, id);
    } catch (e) {
      print('Error deleting notes scent item: $e');
      rethrow;
    }
  }
}