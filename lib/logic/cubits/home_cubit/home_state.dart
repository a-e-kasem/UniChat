part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeGroupsLoading extends HomeState {}

class HomeGroupsLoaded extends HomeState {
  final List<GroupModel> groups;
  HomeGroupsLoaded(this.groups);
}

class HomeGroupsError extends HomeState {
  final String message;
  HomeGroupsError(this.message);
}

