import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:todo/model/note.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'note_event.dart';
part 'note_state.dart';
final notesBox=Hive.box('notes');
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  @override
  NoteState get initialState => NoteInitial();

  @override
  Stream<NoteState> mapEventToState(
    NoteEvent event,
  ) async* {
    if (event is GetNote) {
      // Outputting a state from the asynchronous generator
      int index=event.index;
      Note note = notesBox.getAt(index);
      yield NoteObtained(note);
      print('YOU WANTED THE NOTE ${note.title}');
    }
    if(event is MakeNote){
      String title=event.title;
      DateTime deadlinedate=event.deadlinedate;
      Note note=new Note(title,deadlinedate,0);
      notesBox.add(note);
      print('Added note ${note.title}');
      yield NoteCreated(note);
    }
    if(event is DeleteNote){
      int index=event.index;
      Note toDelete=notesBox.getAt(index);
      notesBox.deleteAt(index);
      print('Deleted note ${toDelete.title}');
      yield NoteDeleted(toDelete);
    }
    if(event is UpdateNote){
      int index=event.index;
      Note note=event.note;
      notesBox.putAt(index,note);
      print('Updated note ${note.title}');
      yield NoteCreated(note);
    }
  }
  }