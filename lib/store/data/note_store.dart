import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:notie/data/db/notes_db.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/colors.dart';
import 'package:notie/global/debug.dart';

part 'note_store.g.dart';

class NoteStore = _NoteStore with _$NoteStore;

abstract class _NoteStore with Store {
  @observable
  Notes notes = Notes();

  @action
  Future<void> getNotes() async {
    notes = await NotesDb.query();
    await debugInitNotes();
    Debug.print(null, 'notes: $notes', minLevel: DiagnosticLevel.info);
  }

  @action
  Future<void> saveNotes() async => await NotesDb.update(notes);

  Future<void> insertNote(Note note) async {
    notes.update(note);
    await saveNotes();
  }

  @action
  Future<void> debugInitNotes() async {
    if (!Debug.isDebug) return;
    if (notes.isNotEmpty) return;
    notes = Notes([
      Note(
        title: 'Note 1',
        content: '[{"insert":"Heading"},{"insert":"\\n","attributes":{"header":1}},{"insert":"bold","attributes":{"bold":true}},{"insert":"\\n"},{"insert":"bold and italic","attributes":{"bold":true,"italic":true}},{"insert":"\\nsome code"},{"insert":"\\n","attributes":{"code-block":true}},{"insert":"A quote"},{"insert":"\\n","attributes":{"blockquote":true}},{"insert":"ordered list"},{"insert":"\\n","attributes":{"list":"ordered"}},{"insert":"unordered list"},{"insert":"\\n","attributes":{"list":"bullet"}},{"insert":"link","attributes":{"link":"pub.dev/packages/quill_markdown"}},{"insert":"\\n"}]',
        colorHex: BgColors.whiteHex,
        createdTimestamp: DateTime(2022, 08, 10).millisecondsSinceEpoch + 1,
        updatedTimestamp: DateTime(2022, 08, 10).millisecondsSinceEpoch + 1,
        deletedTimestamp: 0,
      ),
      Note(
        title: 'Note 2',
        content: '[{"insert":"Heading"},{"insert":"\\n","attributes":{"header":1}},{"insert":"bold","attributes":{"bold":true}},{"insert":"\\n"},{"insert":"bold and italic","attributes":{"bold":true,"italic":true}},{"insert":"\\nsome code"},{"insert":"\\n","attributes":{"code-block":true}},{"insert":"A quote"},{"insert":"\\n","attributes":{"blockquote":true}},{"insert":"ordered list"},{"insert":"\\n","attributes":{"list":"ordered"}},{"insert":"unordered list"},{"insert":"\\n","attributes":{"list":"bullet"}},{"insert":"link","attributes":{"link":"pub.dev/packages/quill_markdown"}},{"insert":"\\n"}]',
        colorHex: BgColors.whiteHex,
        createdTimestamp: DateTime(2022, 09, 20).millisecondsSinceEpoch + 2,
        updatedTimestamp: DateTime(2022, 09, 20).millisecondsSinceEpoch + 2,
        deletedTimestamp: 0,
      ),
      Note(
        title: 'Note 3',
        content: '[{"insert":"Heading"},{"insert":"\\n","attributes":{"header":1}},{"insert":"bold","attributes":{"bold":true}},{"insert":"\\n"},{"insert":"bold and italic","attributes":{"bold":true,"italic":true}},{"insert":"\\nsome code"},{"insert":"\\n","attributes":{"code-block":true}},{"insert":"A quote"},{"insert":"\\n","attributes":{"blockquote":true}},{"insert":"ordered list"},{"insert":"\\n","attributes":{"list":"ordered"}},{"insert":"unordered list"},{"insert":"\\n","attributes":{"list":"bullet"}},{"insert":"link","attributes":{"link":"pub.dev/packages/quill_markdown"}},{"insert":"\\n"}]',
        colorHex: BgColors.whiteHex,
        createdTimestamp: DateTime(2022, 10, 30).millisecondsSinceEpoch + 3,
        updatedTimestamp: DateTime(2022, 10, 30).millisecondsSinceEpoch + 3,
        deletedTimestamp: 0,
      ),
    ]);
    await saveNotes();
  }
}