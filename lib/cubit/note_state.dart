part of 'note_cubit.dart';

@immutable
abstract class NoteState {}

final class NoteInitialstate extends NoteState {}

final class NoteloadingState extends NoteState {}
final class NotesuccessState extends NoteState {}
final class NotefailerState extends NoteState {}


final class NoteloadingStatelogin extends NoteState {}
final class NoteNotloadingStatelogin extends NoteState {}
final class NotesuccessStatelogin extends NoteState {}
final class NotefailerStatelogin extends NoteState {}

final class NoteloadingStateloginE extends NoteState {}
final class NotesuccessStateloginE extends NoteState {}
final class NotefailerStateloginE extends NoteState {}

final class NoteloadingStateSignIn extends NoteState {}
final class NoteNNotloadingStateSignIn extends NoteState {}
final class NotesuccessStateSignIn extends NoteState {}
final class NotefailerStateSignIn extends NoteState {}
