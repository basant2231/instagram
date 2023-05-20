part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}
class userinfoSuccessState extends UserState {}
class userinfoFailedState extends UserState {String message;

/******************************************************************** */
userinfoFailedState({required this.message});}
class userinfoLoadedState extends UserState {}
class ChangeBottomNavIndexState extends UserState {}
/******************************************************************** */
class UserImagePickedFailedState extends UserState {}
class UserImagePickedSuccessState extends UserState {}
/******************************************************************** */
class CameraSelectedSuccess extends UserState {}
class GallerySelectedSuccess extends UserState {}
class CancelSuccess extends UserState {}
