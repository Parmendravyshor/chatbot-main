import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'image_recognition_event.dart';
part 'image_recognition_state.dart';

class ImageRecognitionBloc extends Bloc<ImageRecognitionEvent, ImageRecognitionState> {
  ImageRecognitionBloc() : super(ImageRecognitionInitial()) {
    on<ImageRecognitionEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
