import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muonroi/Models/Stories/models.single.story.dart';
import 'package:muonroi/repository/Story/story_repository.dart';
part 'detail_event.dart';
part 'detail_state.dart';

class DetailStoryPageBloc extends Bloc<DetailStoryEvent, DetailStoryState> {
  final int storyId;
  DetailStoryPageBloc(this.storyId) : super(DetailStoryInitialState()) {
    final StoryRepository storyRepository =
        StoryRepository(pageIndex: 1, pageSize: 15);
    on<GetDetailStory>((event, emit) async {
      try {
        emit(DetailStoryLoadingState());
        final story = await storyRepository.fetchDetailStory(storyId);
        emit(DetailStoryLoadedState(story));
        if (!story.isOk) {
          emit(DetailStoryErrorState(
              story.errorMessages.map((e) => e.toString()).toList().join(',')));
        }
      } on NetworkError {
        emit(const DetailStoryErrorState(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}