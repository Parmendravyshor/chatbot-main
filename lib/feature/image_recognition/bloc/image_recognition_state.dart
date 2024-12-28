part of 'image_recognition_bloc.dart';

sealed class ImageRecognitionState extends Equatable {
  const ImageRecognitionState();
  
  @override
  List<Object> get props => [];
}

final class ImageRecognitionInitial extends ImageRecognitionState {}
