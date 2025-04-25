import 'package:flutter/material.dart';
import '../controllers/notes_scent_controller.dart';
import '../models/notes_scent_model.dart';

class NotesScentsProvider with ChangeNotifier {
  final NotesScentsController _notesScentsController = NotesScentsController();

  List<NotesScentsModel> _items = [];
  bool _isLoading = false;

  List<NotesScentsModel> get items => _items;
  bool get isLoading => _isLoading;

  NotesScentsProvider() {
    fetchNotesScents();
  }

  Future<void> fetchNotesScents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _notesScentsController.fetchNotesScentsItems();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNotesScentsItem(NotesScentsModel item) async {
    await _notesScentsController.addNotesScentsItem(item);
    _items.add(item);
    notifyListeners();
  }

  Future<void> updateNotesScentsItem(NotesScentsModel updatedItem) async {
    await _notesScentsController.updateNotesScentsItem(updatedItem);
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  Future<void> removeNotesScentsItem(String id) async {
    await _notesScentsController.deleteNotesScentsItem(id);
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}