import 'dart:convert';

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:mobx/mobx.dart';
import 'package:notie/data/model/folder.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/debug.dart';
import 'package:notie/global/vars.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  // region observable

  @observable
  String path = FolderPaths.root;

  @observable
  String searchQuery = '';

  @observable
  TextEditingController searchCtrl = TextEditingController();

  @observable
  FocusNode searchFocus = FocusNode();

  @observable
  SortType sortType = SortType.byDefault;

  @observable
  SortOrder sortOrder = SortOrder.descending;

  @observable
  ScrollController scrollCtrl = ScrollController();

  @observable
  bool toolbarVisible = true;

  @observable
  ObservableMap<int, bool> selectedNotes = ObservableMap();

  @observable
  FlipCardController toolFlipCtrl = FlipCardController();

  // endregion

  // region computed

  @computed
  List<Note> get notes {
    var result = <Note>[];
    // region sort & path
    switch (sortType) {
      case SortType.byDefault:
        result = _notes.value;
        break;
      case SortType.byName:
        result = _notes.byName;
        break;
      case SortType.byColor:
        result = _notes.byColor;
        break;
      case SortType.byCreateTime:
        result = _notes.byCreateTime;
        break;
      case SortType.byUpdateTime:
        result = _notes.byUpdateTime;
        break;
      case SortType.byDeleteTime:
        if (path != FolderPaths.trash) {
          sort(SortType.byDefault);
          result = _notes.value;
        } else {
          result = _notes.byDeleteTime;
        }
        break;
    }
    switch (sortOrder) {
      case SortOrder.ascending:
        break;
      case SortOrder.descending:
        result = result.reversed.toList();
        break;
    }
    result.removeWhere((n) => n.path != path);
    // endregion
    // region search
    if (searchQuery.isNotEmpty) {
      result.removeWhere((n) {
        var content = Document.fromJson(jsonDecode(n.content)).toPlainText();
        bool notInTitle = !n.title.toLowerCase().contains(searchQuery);
        bool notInContent = !content.toLowerCase().contains(searchQuery);
        return notInTitle && notInContent;
      });
    }
    // endregion
    return result;
  }

  @computed
  IconData get sortTypeIcon {
    switch (sortType) {
      case SortType.byDefault:
        return Icons.sort_rounded;
      case SortType.byName:
        return Icons.sort_by_alpha_rounded;
      case SortType.byColor:
        return Icons.color_lens_rounded;
      case SortType.byCreateTime:
        return Icons.access_time_rounded;
      case SortType.byUpdateTime:
        return Icons.update_rounded;
      case SortType.byDeleteTime:
        return Icons.delete_rounded;
    }
  }

  @computed
  bool get someSelected => selectedNotes.values.contains(true);

  @computed
  bool get noneSelected => !someSelected;

  @computed
  bool get allSelected =>
      selectedNotes.values.where((e) => e).toList().length ==
      selectedNotes.length;

  @computed
  int get selectedCount => selectedNotes.values.where((e) => e).toList().length;

  // endregion

  @action
  void init() {
    searchCtrl.addListener(() => search(searchCtrl.text));
    scrollCtrl.addListener(() {
      if (scrollCtrl.position.userScrollDirection == ScrollDirection.reverse) {
        hideToolbar();
      } else {
        showToolbar();
      }
    });
  }

  @action
  void dispose() {
    searchCtrl.dispose();
    searchFocus.dispose();
    scrollCtrl.dispose();
  }

  // region Notes actions

  @action
  void setPath(String path) {
    this.path = path;
    Debug.log(null, 'Note folder changed: $path');
  }

  @action
  void search(String query) => searchQuery = query.toLowerCase();

  @action
  void sort(SortType sortType) {
    this.sortType = sortType;
    Debug.info(null, "Sort type changed: $sortType");
  }

  @action
  void order(SortOrder sortOrder) {
    this.sortOrder = sortOrder;
    Debug.info(null, "Sort order changed: $sortOrder");
  }

  @action
  void reverseOrder() => order(sortOrder == SortOrder.ascending
      ? SortOrder.descending
      : SortOrder.ascending);

  @action
  void updateNotes(Notes notes) {
    selectedNotes.clear();
    _notes = notes;
    for (Note note in _notes.value) {
      selectedNotes[note.createdTimestamp] = false;
    }
  }

  // endregion

  // region Toolbar actions

  @action
  Future<void> showToolbar() async {
    _toolbarVisibleTimestamp = DateTime.now().millisecondsSinceEpoch;
    final start = _toolbarVisibleTimestamp;
    await Future.delayed(const Duration(seconds: 3));
    if (start != _toolbarVisibleTimestamp) return;
    toolbarVisible = true;
  }

  @action
  Future<void> hideToolbar() async {
    _toolbarVisibleTimestamp = DateTime.now().millisecondsSinceEpoch;
    final start = _toolbarVisibleTimestamp;
    await Future.delayed(const Duration(seconds: 3));
    if (start != _toolbarVisibleTimestamp) return;
    toolbarVisible = false;
  }

  @action
  void flipToolbar() {
    if (toolFlipCtrl.state?.isFront ?? false) {
      if (someSelected) toolFlipCtrl.toggleCard();
    } else {
      if (noneSelected) toolFlipCtrl.toggleCard();
    }
  }

  // endregion

  // region Select notes actions

  @action
  bool isSelected(Note note) => selectedNotes[note.createdTimestamp] ?? false;

  @action
  bool? select(Note note) {
    final nid = note.createdTimestamp;
    if (selectedNotes[nid] == null) return null;
    selectedNotes[nid] = !selectedNotes[nid]!;
    flipToolbar();
    return selectedNotes[nid];
  }

  @action
  void selectSome(List<Note> notes) {
    for (var note in notes) {
      select(note);
    }
  }

  @action
  void selectAll() {
    final sel = someSelected && !allSelected;
    for (var nid in selectedNotes.keys) {
      selectedNotes[nid] = sel;
    }
    flipToolbar();
  }

  @action
  void unselect() {
    for (var nid in selectedNotes.keys) {
      selectedNotes[nid] = false;
    }
    flipToolbar();
  }

  // endregion

  // region private vars

  Notes _notes = Notes();

  int _toolbarVisibleTimestamp = DateTime.now().millisecondsSinceEpoch;

// endregion
}