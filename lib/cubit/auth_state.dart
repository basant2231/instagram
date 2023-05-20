part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
class SignupLoadingState extends AuthState {}
class SignupSuccesState extends AuthState {}
class SignupFailedState extends AuthState {
  String message;
  SignupFailedState({
    required this.message,
  });
}
  /******************************************************** */
class UserImageSelectedFailedState extends AuthState {}
class UserImageSelectedSuccessState extends AuthState {}
  /******************************************************** */
class LoginFailedState extends AuthState {String message;
  LoginFailedState({
    required this.message,
  });}
class LoginSuccessState extends AuthState {}
class LoginLoadingState extends AuthState {}
class UserInitial extends AuthState {}
/******************************************************************** */
class userinfoSuccessState extends AuthState {}
class userinfoFailedState extends AuthState {String message;

userinfoFailedState({required this.message});}
class userinfoLoadedState extends AuthState {}
class ChangeBottomNavIndexState extends AuthState {}
/******************************************************************** */
class UserImagePickedFailedState extends AuthState {}
class UserImagePickedSuccessState extends AuthState {}
/******************************************************************** */
class CameraSelectedSuccess extends AuthState {}
class GallerySelectedSuccess extends AuthState {}
class CancelSuccess extends AuthState {}
/******************************************************************** */
class uploadPostsFirestoreFailed extends AuthState {String message;
uploadPostsFirestoreFailed({required this.message});
}
class uploadPostsFirestoreSuccess extends AuthState {}
class uploadPostsFirestoreLoading extends AuthState {}
/******************************************************************** */
class PostedSuccessfullyState extends AuthState {String message;
PostedSuccessfullyState({required this.message});
}
class PostedLoadingState extends AuthState {}
class PostedFailedState extends AuthState {String message;
PostedFailedState({required this.message});
}
/**************************************************************** */
class clearimgState extends AuthState {}
/**************************************************************** */
class postsinfoSuccessState extends AuthState {}
class postsinfoFailedState extends AuthState {String message;

postsinfoFailedState({required this.message});}
class postsinfoLoadedState extends AuthState {}
/**************************************************************** */
class LikePostSuccesState extends AuthState {}
class LikePostFailedState extends AuthState {}
/**************************************************************** */
class SendCommentsToFirestoreSuccess extends AuthState {}
class SendCommentsToFirestoreLoading extends AuthState {}
class SendCommentsToFirestoreFailedd extends AuthState {}
/**************************************************************** */
class DeleteFailedToFirestore extends AuthState {}
class DeleteSuccessToFirestore extends AuthState {}


