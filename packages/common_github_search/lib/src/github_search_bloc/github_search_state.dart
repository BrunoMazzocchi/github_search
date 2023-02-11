import 'package:equatable/equatable.dart';

import '../models/models.dart';

abstract class GithubSearchState extends Equatable {
  const GithubSearchState();

  @override
  List<Object> get props => [];
}


//No input has been given
class SearchStateEmpty extends GithubSearchState {}
//Display loading indicator
class SearchStateLoading extends GithubSearchState {}
//Send data to the presentation layer
class SearchStateSuccess extends GithubSearchState {
  const SearchStateSuccess(this.items);

  final List<SearchResultItem> items;

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

//Literately an error
class SearchStateError extends GithubSearchState {
  const SearchStateError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
