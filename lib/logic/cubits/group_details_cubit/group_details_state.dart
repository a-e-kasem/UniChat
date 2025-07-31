part of 'group_details_cubit.dart';

@immutable
abstract class GroupDetailsState {}

class GroupDetailsLoading extends GroupDetailsState {}

class GroupDetailsLoaded extends GroupDetailsState {
  final List<MemberModel> members;
  GroupDetailsLoaded(this.members);
}

class GroupDetailsError extends GroupDetailsState {
  final String message;
  GroupDetailsError(this.message);
}

class GroupDetailsActionSuccess extends GroupDetailsState {
  final String message;
  GroupDetailsActionSuccess(this.message);
}
