part of 'admin_groups_cubit.dart';

@immutable
sealed class AdminGroupsState {}

final class AdminGroupsInitial extends AdminGroupsState {}

final class AdminGroupsLoading extends AdminGroupsState {}

final class AdminGroupsLoaded extends AdminGroupsState {
  final List<GroupModel> groups;

  AdminGroupsLoaded(this.groups);
}

final class AdminGroupsError extends AdminGroupsState {
  final String message;

  AdminGroupsError(this.message);
}


class AdminGroupsSuccess extends AdminGroupsState {
  final String message;
  AdminGroupsSuccess(this.message);
}
