part of 'account_cubit.dart';

@immutable
sealed class AccountState {}

final class AccountInitial extends AccountState {}

final class StartUpdateUserName extends AccountState {}

final class UpdateUserNameSuccess extends AccountState {}

final class UpdateUserNameFailed extends AccountState {}

final class StartUpdateUserImage extends AccountState {}

final class UpdateUserImageSuccess extends AccountState {}

final class UpdateUserImageFailed extends AccountState {}