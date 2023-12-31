part of 'free_bloc.dart';

abstract class FreeStoryEvent extends Equatable {
  const FreeStoryEvent();
  @override
  List<Object> get props => [];
}

class GetFreeStoriesList extends FreeStoryEvent {}

class GroupMoreFreeStoryList extends FreeStoryEvent {
  final int categoryId;
  final bool isPrevious;
  const GroupMoreFreeStoryList(
      {required this.isPrevious, required this.categoryId});
}
