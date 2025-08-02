part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationReceived extends NotificationState {
  final String title;
  final String body;

  NotificationReceived({required this.title, required this.body});
}
