import 'package:flutter/cupertino.dart';
import 'package:common_github_search/common_github_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchBar(),
        _SearchBody(),
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();
  late GithubSearchBloc _githubSearchBloc;


  @override
  void initState() {
    _githubSearchBloc = context.read<GithubSearchBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        _githubSearchBloc.add(
          TextChanged(text: text)
        );
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: GestureDetector(
          onTap: _onClearTapped,
          child: const Icon(Icons.clear),
        ),
        border: InputBorder.none,
        hintText: 'Enter a search term',
      )
    );
  }
  void _onClearTapped() {
    _textController.text = '';
    _githubSearchBloc.add(const TextChanged(text: ''));
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GithubSearchBloc, GithubSearchState> (
      builder: (context, state) {
        if( state is SearchStateLoading ) {
          return const CircularProgressIndicator();
        }

        if( state is SearchStateError) {
          return Text(state.error);
        }

        if (state is SearchStateSuccess) {
          return state.items.isEmpty
              ? const Text('No results')
              : Expanded(child: _SearchResults(items: state.items));
        }
        return const Text('Please enter a term to begin');
      }
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<SearchResultItem>  items;
  const _SearchResults({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
          return _SearchResultItem(item: items[index]);
      }
    );
  }
}


class _SearchResultItem extends StatelessWidget {
  final SearchResultItem item;
  const _SearchResultItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(item.owner.avatarUrl),
      ),
      title: Text(item.fullName),
      subtitle: Text(item.owner.login),
      onTap: () async {
        if( await canLaunchUrl(Uri.parse(item.htmlUrl))) {
          await canLaunchUrl(Uri.parse(item.htmlUrl));
        }
      }
    );
  }
}
