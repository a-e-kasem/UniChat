part of 'swich_pages_cubit.dart';

@immutable
sealed class SwichPagesState {}

final class SwichPagesInitial extends SwichPagesState {}

final class SwichPagesHome extends SwichPagesState {}

final class SwichPagesProfile extends SwichPagesState {}

final class SwichPagesSetting extends SwichPagesState {}
