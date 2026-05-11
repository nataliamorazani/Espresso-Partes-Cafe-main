import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final void Function(String) onSubmit;
  final String title;
  final String hintText;
  const SearchAppBar(
      {Key? key,
      required this.onSubmit,
      required this.title,
      this.hintText = "Pesquisar..."})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    widget.onSubmit("");
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? TextField(
              autofocus: true,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                fillColor: Theme.of(context).colorScheme.onPrimary,
                filled: true,
                border: InputBorder.none,
              ),
              onChanged: widget.onSubmit,
            )
          : Text(widget.title),
      actions: [
        IconButton(
          onPressed: () {
            if (!_isSearching) {
              _startSearch();
            } else {
              _stopSearch();
            }
          },
          icon: Icon(_isSearching ? Icons.close : Icons.search),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
